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

# Define the provider for libvirt
provider "libvirt" {
  uri = "qemu:///system"
}

# Network module to create the libvirt network for the cluster
module "network" {
  source = "./modules/network"
}

# Ignition module to manage ignition files for the bootstrap, master, and worker nodes
module "ignition" {
  source = "./modules/ignition"
}

# Volumes module to create the necessary volumes for the bootstrap, master, and worker nodes
module "volumes" {
  source = "./modules/volumes"
  coreos_image          = var.coreos_image
  bootstrap_volume_size = var.bootstrap_volume_size
  master_volume_size    = var.master_volume_size
  worker_volume_size    = var.worker_volume_size
}

# Domain module to provision the virtual machines (bootstrap, control plane, and workers)
module "volumes" {
  source                  = "./modules/volumes"
  coreos_image            = var.coreos_image
  bootstrap_volume_size   = var.bootstrap_volume_size
  controlplane_1_volume_size = var.controlplane_1_volume_size
  controlplane_2_volume_size = var.controlplane_2_volume_size
  controlplane_3_volume_size = var.controlplane_3_volume_size
  worker_1_volume_size    = var.worker_1_volume_size
  worker_2_volume_size    = var.worker_2_volume_size
  worker_3_volume_size    = var.worker_3_volume_size
}

# Output the node IP addresses for easy access
output "node_ips" {
  value = {
    bootstrap      = module.domain.bootstrap_ip
    controlplane_1 = module.domain.controlplane_1_ip
    controlplane_2 = module.domain.controlplane_2_ip
    controlplane_3 = module.domain.controlplane_3_ip
    worker_1       = module.domain.worker_1_ip
    worker_2       = module.domain.worker_2_ip
    worker_3       = module.domain.worker_3_ip
  }
}
