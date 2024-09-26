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
    http = {
      source = "hashicorp/http"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

provider "local" {}

# Define Ignition data
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

# Base volume for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name       = "fcos_base.qcow2"
  pool       = libvirt_pool.volume_pool.name
  source     = var.coreos_image
  format     = "qcow2"
  depends_on = [libvirt_pool.volume_pool]
}

# Create node volumes
resource "libvirt_volume" "okd_volumes" {
  for_each       = { for node in local.nodes : node.name => node }
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volume_pool.name
  size           = each.value.size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Define nodes
resource "libvirt_domain" "nodes" {
  for_each = { for node in local.nodes : node.name => node }
  name     = each.key
  memory   = each.value.size
  vcpu     = 4 # Assuming 4 vCPUs for all nodes

  cloudinit = libvirt_volume.ignition_volumes["${each.key}-ignition"].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }

  depends_on = [
    libvirt_volume.ignition_volumes,
    libvirt_volume.okd_volumes
  ]
}

# Output node IP addresses
output "node_ips" {
  value = {
    for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0]
  }
}
