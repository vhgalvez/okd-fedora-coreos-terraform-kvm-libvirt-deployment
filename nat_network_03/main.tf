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


data "http" "bootstrap_ignition" {
  url = "http://10.17.3.14/okd/bootstrap.ign"
}

data "http" "master_ignition" {
  url = "http://10.17.3.14/okd/master.ign"
}

data "http" "worker_ignition" {
  url = "http://10.17.3.14/okd/worker.ign"
}

# Define storage pool
resource "libvirt_pool" "volume_pool" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
}

# Base volume for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  pool   = libvirt_pool.volume_pool.name
  source = var.coreos_image
  format = "qcow2"
  depends_on = [libvirt_pool.volume_pool]
}

# Create volumes for bootstrap and control planes
resource "libvirt_volume" "okd_bootstrap" {
  name           = "okd_bootstrap.qcow2"
  pool           = libvirt_pool.volume_pool.name
  size           = var.bootstrap_volume_size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

resource "libvirt_volume" "okd_controlplane_1" {
  name           = "okd_controlplane_1.qcow2"
  pool           = libvirt_pool.volume_pool.name
  size           = var.controlplane_1_volume_size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

resource "libvirt_volume" "okd_controlplane_2" {
  name           = "okd_controlplane_2.qcow2"
  pool           = libvirt_pool.volume_pool.name
  size           = var.controlplane_2_volume_size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

resource "libvirt_volume" "okd_controlplane_3" {
  name           = "okd_controlplane_3.qcow2"
  pool           = libvirt_pool.volume_pool.name
  size           = var.controlplane_3_volume_size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Download Ignition files directly from the web server
data "http" "ignitions" {
  urls = [
    "http://10.17.3.14/okd/bootstrap.ign",
    "http://10.17.3.14/okd/master.ign",
    "http://10.17.3.14/okd/worker.ign"
  ]
}

resource "local_file" "ignition_files" {
  for_each = toset(["bootstrap", "master", "worker"])
  content  = data.http.ignitions.response_bodies[each.key]
  filename = "/tmp/${each.key}.ign"
}

# Create Ignition volumes from downloaded files
resource "libvirt_volume" "ignition_volumes" {
  for_each = toset(["bootstrap", "master", "worker"])
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volume_pool.name
  source   = local_file.ignition_files[each.key].filename
  format   = "raw"
}

# Define node domains
resource "libvirt_domain" "nodes" {
  for_each = {
    bootstrap = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_bootstrap.id }
    master1   = { memory = 16384, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_1.id }
    master2   = { memory = 16384, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_2.id }
    master3   = { memory = 16384, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_3.id }
    worker1   = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_1.id }
    worker2   = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_2.id }
    worker3   = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_3.id }
  }

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = libvirt_volume.ignition_volumes["${each.key == "bootstrap" ? "bootstrap" : "master"}"].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = each.value.volume_id
  }
}

# Output node IP addresses
output "ip_addresses" {
  value = {
    bootstrap = libvirt_domain.nodes["bootstrap"].network_interface[0].addresses[0]
    masters   = [
      libvirt_domain.nodes["master1"].network_interface[0].addresses[0],
      libvirt_domain.nodes["master2"].network_interface[0].addresses[0],
      libvirt_domain.nodes["master3"].network_interface[0].addresses[0]
    ]
    workers   = [
      libvirt_domain.nodes["worker1"].network_interface[0].addresses[0],
      libvirt_domain.nodes["worker2"].network_interface[0].addresses[0],
      libvirt_domain.nodes["worker3"].network_interface[0].addresses[0]
    ]
  }
}
