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
  source                     = "./modules/volumes"
  coreos_image               = var.coreos_image
  bootstrap_volume_size      = var.bootstrap_volume_size
  controlplane_1_volume_size = var.controlplane_1_volume_size
  controlplane_2_volume_size = var.controlplane_2_volume_size
  controlplane_3_volume_size = var.controlplane_3_volume_size
  worker_1_volume_size       = var.worker_1_volume_size
  worker_2_volume_size       = var.worker_2_volume_size
  worker_3_volume_size       = var.worker_3_volume_size
}


module "domain" {
  source                = "./modules/domain"
  network_name          = module.network.network_name
  bootstrap_ignition    = module.ignition.bootstrap_ignition
  controlplane_ignition = module.ignition.controlplane_ignition
  worker_ignition       = module.ignition.worker_ignition
  bootstrap_volume      = module.volumes.bootstrap_volume
  controlplane_1_volume = module.volumes.controlplane_1_volume
  controlplane_2_volume = module.volumes.controlplane_2_volume
  controlplane_3_volume = module.volumes.controlplane_3_volume
  worker_1_volume       = module.volumes.worker_1_volume
  worker_2_volume       = module.volumes.worker_2_volume
  worker_3_volume       = module.volumes.worker_3_volume

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  worker_1       = var.worker_1
  worker_2       = var.worker_2
  worker_3       = var.worker_3
}
