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

  network_id            = module.network.network_id
  bootstrap_ignition_id = module.ignition.bootstrap_ignition.id
  master_ignition_id    = module.ignition.master_ignition.id
  worker_ignition_id    = module.ignition.worker_ignition.id

  bootstrap_volume_id      = module.volumes.bootstrap_volume.id
  controlplane_1_volume_id = module.volumes.controlplane_1_volume.id
  controlplane_2_volume_id = module.volumes.controlplane_2_volume.id
  controlplane_3_volume_id = module.volumes.controlplane_3_volume.id
  worker_1_volume_id       = module.volumes.worker_1_volume.id
  worker_2_volume_id       = module.volumes.worker_2_volume.id
  worker_3_volume_id       = module.volumes.worker_3_volume.id

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  worker_1       = var.worker_1
  worker_2       = var.worker_2
  worker_3       = var.worker_3
}
