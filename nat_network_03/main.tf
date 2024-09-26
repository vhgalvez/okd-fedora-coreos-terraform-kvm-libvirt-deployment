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

# Define and start the storage pool (Ensure the path exists)
resource "libvirt_pool" "volume_pool" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
}

# Download Fedora CoreOS base image
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base"
  pool   = libvirt_pool.volume_pool.name
  source = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
  format = "qcow2"

  depends_on = [libvirt_pool.volume_pool]
}

# Download Ignition files directly from the web server
data "http" "bootstrap_ignition" {
  url = "http://10.17.3.14/okd/bootstrap.ign"
}

data "http" "master_ignition" {
  url = "http://10.17.3.14/okd/master.ign"
}

data "http" "worker_ignition" {
  url = "http://10.17.3.14/okd/worker.ign"
}

# Create Ignition volumes from downloaded files
resource "libvirt_volume" "bootstrap_ign" {
  name   = "bootstrap-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = data.http.bootstrap_ignition.response_body
  format = "raw"
}

resource "libvirt_volume" "master_ign" {
  count  = 3
  name   = "master-${count.index + 1}-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = data.http.master_ignition.response_body
  format = "raw"
}

resource "libvirt_volume" "worker_ign" {
  count  = 3
  name   = "worker-${count.index + 1}-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = data.http.worker_ignition.response_body
  format = "raw"
}

# Define the bootstrap node
resource "libvirt_domain" "bootstrap" {
  name   = "bootstrap"
  memory = "8192"
  vcpu   = 4

  cloudinit = libvirt_volume.bootstrap_ign.id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }
}

# Define master nodes
resource "libvirt_domain" "master" {
  count  = 3
  name   = "master-${count.index + 1}"
  memory = "16384"
  vcpu   = 4

  cloudinit = libvirt_volume.master_ign[count.index].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }
}

# Define worker nodes
resource "libvirt_domain" "worker" {
  count  = 3
  name   = "worker-${count.index + 1}"
  memory = "8192"
  vcpu   = 4

  cloudinit = libvirt_volume.worker_ign[count.index].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }
}

# Output node IP addresses
output "ip_addresses" {
  value = {
    bootstrap = libvirt_domain.bootstrap.network_interface[0].addresses[0]
    master    = libvirt_domain.master[*].network_interface[0].addresses[0]
    worker    = libvirt_domain.worker[*].network_interface[0].addresses[0]
  }
}
