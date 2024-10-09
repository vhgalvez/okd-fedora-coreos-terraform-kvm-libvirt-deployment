# main.tf
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

provider "libvirt" {
  uri = "qemu:///system"
}

# Load network module
module "network" {
  source = "./modules/network"
}

# Load ignition module
module "ignition" {
  source = "./modules/ignition"
}

# Load volume module
module "volumes" {
  source             = "./modules/volumes"
  coreos_base_volume = module.network.coreos_image
}

# Load domain module
module "domain" {
  source = "./modules/domain"

  bootstrap = {
    name         = var.bootstrap.name
    memory       = var.bootstrap.memory
    vcpu         = var.bootstrap.vcpu
    address      = var.bootstrap.address
    mac          = var.bootstrap.mac
  }

  bootstrap_ignition = module.ignition.bootstrap_ignition
  bootstrap_volume   = module.volumes.bootstrap_volume
  network_name       = module.network.network_name
}
