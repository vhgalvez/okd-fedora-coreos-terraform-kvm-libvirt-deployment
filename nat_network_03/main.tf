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

module "network" {
  source = "./modules/network"
}

module "ignition" {
  source = "./modules/ignition"
}

module "volumes" {
  source = "./modules/volumes"
}


module "domain" {
  source = "./modules/domain"

  # Network
  network_name = module.network.network_name

  # Ignition files
  bootstrap_ignition = module.ignition.bootstrap_ignition
  master_ignition    = module.ignition.master_ignition
  worker_ignition    = module.ignition.worker_ignition

  # Volumes
  bootstrap_volume      = module.volumes.bootstrap_volume
  controlplane_1_volume = module.volumes.controlplane_1_volume
  controlplane_2_volume = module.volumes.controlplane_2_volume
  controlplane_3_volume = module.volumes.controlplane_3_volume
  worker_1_volume       = module.volumes.worker_1_volume
  worker_2_volume       = module.volumes.worker_2_volume
  worker_3_volume       = module.volumes.worker_3_volume

  # Node definitions
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  worker_1       = var.worker_1
  worker_2       = var.worker_2
  worker_3       = var.worker_3
}
