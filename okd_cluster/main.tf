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

# Módulo de red para configurar la red del clúster
module "network" {
  source = "./modules/network"
}

# Módulo de Ignition para gestionar las configuraciones de Ignition de los nodos
module "ignition" {
  source = "./modules/ignition"
}

# Módulo de volúmenes para gestionar los volúmenes de almacenamiento de los nodos del clúster
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

# Módulo de dominios para crear las VMs para bootstrap, control plane y nodos worker
module "domain" {
  source = "./modules/domain"

  network_id            = module.network.network_id          
  bootstrap_ignition_id = module.ignition.bootstrap_ignition 
  master_ignition_id    = module.ignition.master_ignition    
  worker_ignition_id    = module.ignition.worker_ignition    

  bootstrap_volume_id      = module.volumes.bootstrap_volume      
  controlplane_1_volume_id = module.volumes.controlplane_1_volume 
  controlplane_2_volume_id = module.volumes.controlplane_2_volume 
  controlplane_3_volume_id = module.volumes.controlplane_3_volume 
  worker_1_volume_id       = module.volumes.worker_1_volume       
  worker_2_volume_id       = module.volumes.worker_2_volume     
  worker_3_volume_id       = module.volumes.worker_3_volume

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  worker_1       = var.worker_1
  worker_2       = var.worker_2
  worker_3       = var.worker_3
}
