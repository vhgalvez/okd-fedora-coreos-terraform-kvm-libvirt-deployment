# main.tf
terraform {
  required_version = ">= 1.9.6"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Create the new NAT-based network kube_network_03
resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
  dhcp {
    enabled = true
  }
}

# Ensure the directory is created before anything else
resource "null_resource" "create_volumetmp_directory" {
  provisioner "local-exec" {
    when    = create
    command = "sudo mkdir -p /mnt/lv_data/organized_storage/volumes/volumetmp_03 && sudo chmod 755 /mnt/lv_data/organized_storage/volumes/volumetmp_03"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sudo rm -rf /mnt/lv_data/organized_storage/volumes/volumetmp_03"
  }
}

# Define a storage pool
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [null_resource.create_volumetmp_directory]
}

# Define local paths to Ignition files
locals {
  ignition_files = {
    "bootstrap" = "${path.module}/okd-install/bootstrap.ign"
    "master1"   = "${path.module}/okd-install/master.ign"
    "master2"   = "${path.module}/okd-install/master.ign"
    "master3"   = "${path.module}/okd-install/master.ign"
    "worker1"   = "${path.module}/okd-install/worker.ign"
    "worker2"   = "${path.module}/okd-install/worker.ign"
    "worker3"   = "${path.module}/okd-install/worker.ign"
  }
}

# Create Ignition volumes
resource "libvirt_ignition" "ignitions" {
  for_each = local.ignition_files

  name    = "${each.key}-ignition"
  content = file(each.value)
}

# Create a base volume for Fedora CoreOS
resource "libvirt_volume" "coreos_image" {
  name   = "coreos_image.qcow2"
  pool   = libvirt_pool.volumetmp_03.name
  source = var.coreos_image
  format = "qcow2"

  depends_on = [libvirt_pool.volumetmp_03]
}

# Create individual node volumes based on the base image
resource "libvirt_volume" "okd_volumes" {
  for_each       = var.vm_definitions
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volumetmp_03.name
  size           = each.value.disk_size * 1048576 # Convert MB to bytes
  base_volume_id = libvirt_volume.coreos_image.id # Corrected reference

  depends_on = [libvirt_volume.coreos_image] # Corrected reference
}

# Define VMs with network and disk attachments
resource "libvirt_domain" "nodes" {
  for_each = var.vm_definitions
  name     = "okd-${each.key}"
  memory   = each.value.memory
  vcpu     = each.value.cpus

  # Use the correct Ignition volume
  cloudinit = libvirt_ignition.ignitions[each.key].id

  # Connect VMs to the kube_network_03 network
  network_interface {
    network_id     = libvirt_network.kube_network_03.id
    wait_for_lease = true # Enable this to ensure DHCP assigns an IP address
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  # Disable QEMU agent communication to prevent retrieval issues
  qemu_agent = false

  depends_on = [libvirt_volume.okd_volumes, libvirt_network.kube_network_03]
}

# Output node IP addresses
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}
