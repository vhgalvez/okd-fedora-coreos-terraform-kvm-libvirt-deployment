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

# Download Ignition files for bootstrap, master, and worker nodes
data "http" "bootstrap_ignition" {
  url = "http://10.17.3.14/okd/bootstrap.ign"
}

data "http" "master_ignition" {
  url = "http://10.17.3.14/okd/master.ign"
}

data "http" "worker_ignition" {
  url = "http://10.17.3.14/okd/worker.ign"
}

# Define storage pool for the volumes
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

# Create local Ignition files from the HTTP data sources
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

# Create Ignition volumes from downloaded Ignition files
resource "libvirt_volume" "bootstrap_ignition_volume" {
  name   = "bootstrap-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = local_file.bootstrap_ignition_file.filename
  format = "raw"
}

resource "libvirt_volume" "master_ignition_volume" {
  name   = "master-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = local_file.master_ignition_file.filename
  format = "raw"
}

resource "libvirt_volume" "worker_ignition_volume" {
  name   = "worker-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = local_file.worker_ignition_file.filename
  format = "raw"
}

# Define the nodes (bootstrap, masters, workers) with their respective Ignition volumes
resource "libvirt_domain" "nodes" {
  for_each = {
    bootstrap = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_bootstrap.id, ignition_volume = libvirt_volume.bootstrap_ignition_volume.id }
    master1   = { memory = 16384, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_1.id, ignition_volume = libvirt_volume.master_ignition_volume.id }
    master2   = { memory = 16384, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_2.id, ignition_volume = libvirt_volume.master_ignition_volume.id }
    master3   = { memory = 16384, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_3.id, ignition_volume = libvirt_volume.master_ignition_volume.id }
    worker1   = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_1.id, ignition_volume = libvirt_volume.worker_ignition_volume.id }
    worker2   = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_2.id, ignition_volume = libvirt_volume.worker_ignition_volume.id }
    worker3   = { memory = 8192, vcpu = 4, volume_id = libvirt_volume.okd_controlplane_3.id, ignition_volume = libvirt_volume.worker_ignition_volume.id }
  }

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = each.value.ignition_volume

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
