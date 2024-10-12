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

# Módulo de red
module "network" {
  source = "./modules/network"
}

# Módulo de Ignition
module "ignition" {
  source = "./modules/ignition"
}

# Módulo de volúmenes
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

# Módulo de dominios
module "domain" {
  source       = "./modules/domain"
  network_name = var.network_name

  # Pasar coreos_image al módulo
  coreos_image = var.coreos_image

  bootstrap_ignition_id = module.ignition.bootstrap_ignition
  master_ignition_id    = module.ignition.master_ignition
  worker_ignition_id    = module.ignition.worker_ignition

  bootstrap_volume_id      = module.volumes.bootstrap_volume.id
  controlplane_1_volume_id = module.volumes.controlplane_1_volume.id
  controlplane_2_volume_id = module.volumes.controlplane_2_volume.id
  controlplane_3_volume_id = module.volumes.controlplane_3_volume.id
  worker_1_volume_id       = module.volumes.worker_1_volume.id
  worker_2_volume_id       = module.volumes.worker_2_volume.id
  worker_3_volume_id       = module.volumes.worker_3_volume.id
}



# Outputs
output "bootstrap" {
  value = module.domain.okd_bootstrap
}

output "controlplane_1" {
  value = module.domain.okd_controlplane_1
}

output "controlplane_2" {
  value = module.domain.okd_controlplane_2
}

output "controlplane_3" {
  value = module.domain.okd_controlplane_3
}

output "worker_1" {
  value = module.domain.okd_worker_1
}

output "worker_2" {
  value = module.domain.okd_worker_2
}

output "worker_3" {
  value = module.domain.okd_worker_3
}
