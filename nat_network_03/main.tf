terraform {
  required_version = ">= 1.9.5"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

provider "local" {}

# Define Ignition files for nodes
data "http" "ignitions" {
  urls = {
    bootstrap = "http://10.17.3.14/okd/bootstrap.ign"
    master    = "http://10.17.3.14/okd/master.ign"
    worker    = "http://10.17.3.14/okd/worker.ign"
  }
}

# Define storage pool for volumes
resource "libvirt_pool" "volume_pool" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
}

# Base volume for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name       = "fcos_base.qcow2"
  pool       = libvirt_pool.volume_pool.name
  source     = var.coreos_image
  format     = "qcow2"
  depends_on = [libvirt_pool.volume_pool]
}

# Define VM volumes
locals {
  nodes = [
    { name = "bootstrap", size = var.bootstrap_volume_size, ignition = "bootstrap" },
    { name = "master1", size = var.master_volume_size, ignition = "master" },
    { name = "master2", size = var.master_volume_size, ignition = "master" },
    { name = "master3", size = var.master_volume_size, ignition = "master" },
    { name = "worker1", size = var.worker_volume_size, ignition = "worker" },
    { name = "worker2", size = var.worker_volume_size, ignition = "worker" },
    { name = "worker3", size = var.worker_volume_size, ignition = "worker" },
  ]
}

# Create node volumes
resource "libvirt_volume" "okd_volumes" {
  for_each = toset(local.nodes[*].name)
  name     = "${each.key}.qcow2"
  pool     = libvirt_pool.volume_pool.name
  size     = local.nodes[each.key].size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Create Ignition volumes
resource "local_file" "ignition_files" {
  for_each = toset(local.nodes[*].ignition)
  content  = data.http.ignitions.response_bodies[each.key]
  filename = "/tmp/${each.key}.ign"
}

resource "libvirt_volume" "ignition_volumes" {
  for_each = toset(local.nodes[*].ignition)
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volume_pool.name
  source   = local_file.ignition_files[each.key].filename
  format   = "raw"
}

# Define nodes
resource "libvirt_domain" "nodes" {
  for_each = toset(local.nodes[*].name)
  name     = each.key
  memory   = lookup(var.vm_definitions[each.key], "memory")
  vcpu     = lookup(var.vm_definitions[each.key], "cpus")

  cloudinit = libvirt_volume.ignition_volumes[local.nodes[each.key].ignition].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }
}

output "node_ips" {
  value = {
    for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0]
  }
}
