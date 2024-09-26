# main.tf
terraform {
  required_version = ">= 1.9.5"
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

# Define network for the cluster
resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}

# Create Storage Pool for Terraform managed volumes
resource "libvirt_pool" "okd_storage_pool" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  # Ensure that the pool exists before creating volumes
  lifecycle {
    create_before_destroy = true
  }
}

# Dependencia para asegurar la creación del pool antes de cualquier uso
resource "null_resource" "create_pool_directory" {
  provisioner "local-exec" {
    command = "mkdir -p /mnt/lv_data/organized_storage/volumes/volumetmp_03"
  }
}

# Define Fedora CoreOS base image
resource "libvirt_volume" "base" {
  name   = "fedora-coreos-base"
  source = var.base_image
  pool   = libvirt_pool.okd_storage_pool.name
  format = "qcow2"
  depends_on = [libvirt_pool.okd_storage_pool, null_resource.create_pool_directory]
}

# VM Disk for each node
resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_definitions

  name           = "${each.key}-disk"
  base_volume_id = libvirt_volume.base.id
  pool           = libvirt_pool.okd_storage_pool.name
  format         = "qcow2"
  size           = each.value.disk_size * 1024 * 1024
  depends_on = [libvirt_pool.okd_storage_pool, libvirt_volume.base]
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

# Ignition for Master Nodes
resource "libvirt_ignition" "master_ignition" {
  name    = "master.ign"
  pool    = libvirt_pool.okd_storage_pool.name
  content = file("/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/master.ign")
  depends_on = [libvirt_pool.okd_storage_pool, null_resource.generate_ignition]
}

# Ignition for Worker Nodes
resource "libvirt_ignition" "worker_ignition" {
  name    = "worker.ign"
  pool    = libvirt_pool.okd_storage_pool.name
  content = file("/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/worker.ign")
  depends_on = [libvirt_pool.okd_storage_pool, null_resource.generate_ignition]
}

# Ignition for Bootstrap Node
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "bootstrap.ign"
  pool    = libvirt_pool.okd_storage_pool.name
  content = file("/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/bootstrap.ign")
  depends_on = [libvirt_pool.okd_storage_pool, null_resource.generate_ignition]
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

  # Use the correct ignition file based on the node type
  coreos_ignition = lookup(
    {
      "bootstrap" = libvirt_ignition.bootstrap_ignition.id,
      "master1"   = libvirt_ignition.master_ignition.id,
      "master2"   = libvirt_ignition.master_ignition.id,
      "master3"   = libvirt_ignition.master_ignition.id,
      "worker1"   = libvirt_ignition.worker_ignition.id,
      "worker2"   = libvirt_ignition.worker_ignition.id,
      "worker3"   = libvirt_ignition.worker_ignition.id
    },
    each.key,
    libvirt_ignition.worker_ignition.id
  )

  graphics {
    type = "vnc"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0" # Adding the required target_port argument
  }

  qemu_agent = true

  depends_on = [libvirt_ignition.master_ignition, libvirt_ignition.worker_ignition, libvirt_ignition.bootstrap_ignition]
}

# Output IP addresses
output "okd_vm_ips" {
  value = { for key, vm in libvirt_domain.okd_vm : key => vm.network_interface[0].addresses[0] }
}
