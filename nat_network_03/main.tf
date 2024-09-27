# main.tf
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

provider "local" {}

# Define storage pool for volumes
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
}

# Base volume definition for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  source = var.base_image
  pool   = libvirt_pool.volumetmp_03.name
  format = "qcow2"
}

# Fetch Ignition configuration files for Bootstrap, Master, and Worker nodes
data "http" "bootstrap_ignition" {
  url = "http://10.17.3.14/okd/bootstrap.ign"
}

data "http" "master_ignition" {
  url = "http://10.17.3.14/okd/master.ign"
}

data "http" "worker_ignition" {
  url = "http://10.17.3.14/okd/worker.ign"
}

# Create local Ignition files
resource "local_file" "bootstrap_ignition_file" {
  content  = data.http.bootstrap_ignition.response_body
  filename = "/tmp/bootstrap.ign"
}

resource "local_file" "master_ignition_file" {
  content  = data.http.master_ignition.response_body
  filename = "/tmp/master.ign"
}

resource "local_file" "worker_ignition_file" {
  content  = data.http.worker_ignition.response_body
  filename = "/tmp/worker.ign"
}

# Define node configurations
locals {
  nodes = {
    bootstrap = { size = var.bootstrap_volume_size, ignition_file = local_file.bootstrap_ignition_file.filename },
    master1   = { size = var.master_volume_size, ignition_file = local_file.master_ignition_file.filename },
    master2   = { size = var.master_volume_size, ignition_file = local_file.master_ignition_file.filename },
    master3   = { size = var.master_volume_size, ignition_file = local_file.master_ignition_file.filename },
    worker1   = { size = var.worker_volume_size, ignition_file = local_file.worker_ignition_file.filename },
    worker2   = { size = var.worker_volume_size, ignition_file = local_file.worker_ignition_file.filename },
    worker3   = { size = var.worker_volume_size, ignition_file = local_file.worker_ignition_file.filename },
  }
}

# Create Ignition volumes
resource "libvirt_volume" "ignition_volumes" {
  for_each = local.nodes
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volumetmp_03.name
  source   = each.value.ignition_file
  format   = "raw"
}

# Create node volumes
resource "libvirt_volume" "okd_volumes" {
  for_each       = local.nodes
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volumetmp_03.name
  size           = each.value.size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Define libvirt domains for nodes
resource "libvirt_domain" "nodes" {
  for_each = local.nodes
  name     = each.key
  memory   = var.vm_definitions[each.key].memory
  vcpu     = var.vm_definitions[each.key].cpus

  cloudinit = libvirt_volume.ignition_volumes[each.key].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }
}

# Output node IP addresses
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}
