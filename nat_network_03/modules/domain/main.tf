# modules/domain/main.tf

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


resource "libvirt_domain" "okd_bootstrap" {
  name            = var.bootstrap.name
  memory          = var.bootstrap.memory * 1024
  vcpu            = var.bootstrap.vcpu
  running         = true
  coreos_ignition = var.bootstrap_ignition

  disk {
    volume_id = var.bootstrap_volume
  }

  network_interface {
    network_name = var.network_name
    hostname     = var.bootstrap.name
    addresses    = [var.bootstrap.address]
    mac          = var.bootstrap.mac
  }
}

# Define similar resources for master and worker nodes...
