# main.tf
terraform {
  required_version = ">= 1.9.5"
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

# Define a storage pool
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  lifecycle {
    create_before_destroy = true
  }
}

# Create volumes for each Ignition file
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/bootstrap.ign"
  format = "raw"
}

resource "libvirt_volume" "master1_ignition" {
  name   = "master1-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/master1.ign"
  format = "raw"
}

resource "libvirt_volume" "master2_ignition" {
  name   = "master2-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/master2.ign"
  format = "raw"
}

resource "libvirt_volume" "master3_ignition" {
  name   = "master3-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/master3.ign"
  format = "raw"
}

resource "libvirt_volume" "worker1_ignition" {
  name   = "worker1-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/worker1.ign"
  format = "raw"
}

resource "libvirt_volume" "worker2_ignition" {
  name   = "worker2-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/worker2.ign"
  format = "raw"
}

resource "libvirt_volume" "worker3_ignition" {
  name   = "worker3-ignition"
  pool   = libvirt_pool.volumetmp_03.name
  source = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/worker3.ign"
  format = "raw"
}

# Create a base volume for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  pool   = libvirt_pool.volumetmp_03.name
  source = var.coreos_image
  format = "qcow2"
}

# Create individual node volumes based on the base image
resource "libvirt_volume" "okd_volumes" {
  for_each = var.vm_definitions
  name     = "${each.key}.qcow2"
  pool     = libvirt_pool.volumetmp_03.name
  size     = each.value.disk_size * 1048576  # Convert MB to bytes
  base_volume_id = libvirt_volume.fcos_base.id
}

# Define VMs with network and disk attachments
resource "libvirt_domain" "nodes" {
  for_each = var.vm_definitions
  name     = "okd-${each.key}"
  memory   = each.value.memory
  vcpu     = each.value.cpus

  # Link the cloudinit to the correct volume
  cloudinit = lookup(
    {
      "bootstrap" = libvirt_volume.bootstrap_ignition.id,
      "master1"   = libvirt_volume.master1_ignition.id,
      "master2"   = libvirt_volume.master2_ignition.id,
      "master3"   = libvirt_volume.master3_ignition.id,
      "worker1"   = libvirt_volume.worker1_ignition.id,
      "worker2"   = libvirt_volume.worker2_ignition.id,
      "worker3"   = libvirt_volume.worker3_ignition.id
    },
    each.key
  )

  network_interface {
    network_name = "kube_network_02"
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }
}

# Output node IP addresses
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}
