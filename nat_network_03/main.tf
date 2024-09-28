terraform {
  required_version = ">= 1.9.5"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Define storage pool
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  lifecycle {
    create_before_destroy = true
  }
}

# Define node configurations with the correct Ignition URLs
locals {
  nodes = {
    bootstrap = { size = var.bootstrap_volume_size, file = "http://10.17.3.14/okd/bootstrap.ign" },
    master1   = { size = var.master_volume_size, file = "http://10.17.3.14/okd/master.ign" },
    master2   = { size = var.master_volume_size, file = "http://10.17.3.14/okd/master.ign" },
    master3   = { size = var.master_volume_size, file = "http://10.17.3.14/okd/master.ign" },
    worker1   = { size = var.worker_volume_size, file = "http://10.17.3.14/okd/worker.ign" },
    worker2   = { size = var.worker_volume_size, file = "http://10.17.3.14/okd/worker.ign" },
    worker3   = { size = var.worker_volume_size, file = "http://10.17.3.14/okd/worker.ign" }
  }
}

# Create Ignition volumes for nodes
resource "libvirt_volume" "ignition_volumes" {
  for_each = local.nodes
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volumetmp_03.name
  # Refers to the Ignition file served via HTTP
  source   = each.value.file
  format   = "raw"
}

# Create base volume for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  pool   = libvirt_pool.volumetmp_03.name
  source = var.coreos_image
  format = "qcow2"
}

# Create node volumes based on the base image
resource "libvirt_volume" "okd_volumes" {
  for_each       = local.nodes
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volumetmp_03.name
  size           = each.value.size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Define VMs with network and disk attachments
resource "libvirt_domain" "nodes" {
  for_each = local.nodes
  name     = each.key
  memory   = var.vm_definitions[each.key].memory
  vcpu     = var.vm_definitions[each.key].cpus

  cloudinit = libvirt_volume.ignition_volumes[each.key].id

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
