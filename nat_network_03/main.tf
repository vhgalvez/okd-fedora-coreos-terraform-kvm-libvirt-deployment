terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Create the directory for the storage pool
resource "null_resource" "create_pool_directory" {
  provisioner "local-exec" {
    command = "sudo mkdir -p /mnt/lv_data/organized_storage/volumes/volumetmp_03"
  }
}

# Define and create the storage pool
resource "libvirt_pool" "okd_storage_pool" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  depends_on = [null_resource.create_pool_directory]

  # Ensure the pool is handled correctly
  lifecycle {
    ignore_changes = [
      path,
    ]
  }
}

# Define the network for VMs
resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}

# Define the base image volume
resource "libvirt_volume" "base" {
  name   = "fedora-coreos-base"
  source = var.base_image
  pool   = libvirt_pool.okd_storage_pool.name
  format = "qcow2"
  depends_on = [libvirt_pool.okd_storage_pool]
}

# Define disks for each VM
resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_definitions

  name           = "${each.key}-disk"
  base_volume_id = libvirt_volume.base.id
  pool           = libvirt_pool.okd_storage_pool.name
  format         = "qcow2"
  size           = each.value.disk_size * 1024 * 1024
  depends_on = [libvirt_volume.base]
}

# Generate Ignition with OpenShift Installer
resource "null_resource" "generate_ignition" {
  provisioner "local-exec" {
    command = "openshift-install create ignition-configs --dir=/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install"
  }

  triggers = {
    always_run = timestamp()
  }
}

# Define Ignition configs for Masters, Workers, and Bootstrap
resource "libvirt_ignition" "ignition_configs" {
  for_each = {
    "bootstrap" = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/bootstrap.ign"
    "master"    = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/master.ign"
    "worker"    = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/worker.ign"
  }

  name    = "${each.key}-ign"
  pool    = libvirt_pool.okd_storage_pool.name
  content = file(each.value)
  depends_on = [null_resource.generate_ignition]
}

# Define virtual machines
resource "libvirt_domain" "okd_vm" {
  for_each = var.vm_definitions

  name   = each.key
  vcpu   = each.value.cpus
  memory = each.value.memory

  network_interface {
    network_id     = libvirt_network.okd_network.id
    wait_for_lease = true
    addresses      = [each.value.ip]
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  coreos_ignition = libvirt_ignition.ignition_configs[each.value.role].id

  graphics {
    type = "vnc"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  qemu_agent = true

  depends_on = [
    libvirt_ignition.ignition_configs,
    libvirt_pool.okd_storage_pool
  ]
}

# Output IP addresses
output "okd_vm_ips" {
  value = { for key, vm in libvirt_domain.okd_vm : key => vm.network_interface[0].addresses[0] }
}
