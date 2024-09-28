terraform {
  required_version = ">= 1.9.5"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
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

# Define a storage pool
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  lifecycle {
    create_before_destroy = true
  }
}

# Download Ignition files locally
data "http" "ignition_files" {
  for_each = {
    "bootstrap" = "http://10.17.3.14/okd/bootstrap.ign"
    "master1"   = "http://10.17.3.14/okd/master.ign"
    "master2"   = "http://10.17.3.14/okd/master.ign"
    "master3"   = "http://10.17.3.14/okd/master.ign"
    "worker1"   = "http://10.17.3.14/okd/worker.ign"
    "worker2"   = "http://10.17.3.14/okd/worker.ign"
    "worker3"   = "http://10.17.3.14/okd/worker.ign"
  }
  url = each.value
}

# Save Ignition files locally
resource "local_file" "ignition_files" {
  for_each = data.http.ignition_files
  content  = each.value.body
  filename = "/mnt/lv_data/organized_storage/volumes/volumetmp_03/${each.key}.ign"
}

# Create Ignition volumes for nodes
resource "libvirt_volume" "ignition_volumes" {
  for_each = local_file.ignition_files
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volumetmp_03.name
  source   = each.value.filename
  format   = "raw"
}

# Download Fedora CoreOS base image and create base volume
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  pool   = libvirt_pool.volumetmp_03.name
  source = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/latest.x86_64/fedora-coreos-qemu.x86_64.qcow2.xz"
  format = "qcow2"
}

# Create individual node volumes based on the base image
resource "libvirt_volume" "okd_volumes" {
  for_each = data.http.ignition_files
  name     = "${each.key}.qcow2"
  pool     = libvirt_pool.volumetmp_03.name
  size     = var.volume_sizes[each.key] * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Define VMs with network and disk attachments
resource "libvirt_domain" "nodes" {
  for_each = data.http.ignition_files
  name     = "okd-${each.key}"
  memory   = var.vm_memory[each.key]
  vcpu     = var.vm_cpus[each.key]

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
