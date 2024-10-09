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

# Network module to set up the network for the cluster
module "network" {
  source = "./modules/network"
}

# Ignition module to manage Ignition configurations for the nodes
module "ignition" {
  source = "./modules/ignition"
}

# Volumes module to manage storage volumes for the cluster nodes
module "volumes" {
  source = "./modules/volumes"

  coreos_image               = var.coreos_image
  bootstrap_volume_size      = var.bootstrap_volume_size
  controlplane_1_volume_size = var.controlplane_1_volume_size
  controlplane_2_volume_size = var.controlplane_2_volume_size
  controlplane_3_volume_size = var.controlplane_3_volume_size
  worker_1_volume_size       = var.worker_1_volume_size
  worker_2_volume_size       = var.worker_2_volume_size
  worker_3_volume_size       = var.worker_3_volume_size
}

# Domain module to create the VMs for the bootstrap, control plane, and worker nodes
module "domain" {
  source = "./modules/domain"

  network_id            = module.network.network_name  # Corrected: "network_name" is the correct attribute
  bootstrap_ignition_id = module.ignition.bootstrap_ignition  # Corrected: removed ".id"
  master_ignition_id    = module.ignition.master_ignition     # Corrected: removed ".id"
  worker_ignition_id    = module.ignition.worker_ignition     # Corrected: removed ".id"

  bootstrap_volume_id      = module.volumes.bootstrap_volume      # Corrected: removed ".id"
  controlplane_1_volume_id = module.volumes.controlplane_1_volume # Corrected: removed ".id"
  controlplane_2_volume_id = module.volumes.controlplane_2_volume # Corrected: removed ".id"
  controlplane_3_volume_id = module.volumes.controlplane_3_volume # Corrected: removed ".id"
  worker_1_volume_id       = module.volumes.worker_1_volume       # Corrected: removed ".id"
  worker_2_volume_id       = module.volumes.worker_2_volume       # Corrected: removed ".id"
  worker_3_volume_id       = module.volumes.worker_3_volume       # Corrected: removed ".id"

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  worker_1       = var.worker_1
  worker_2       = var.worker_2
  worker_3       = var.worker_3
}
