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

  network_id            = module.network.network_id             # Correcto: Usamos "network_id" que es el UUID de la red
  bootstrap_ignition_id = module.ignition.bootstrap_ignition.id # Usamos ".id" para obtener el ID correcto
  master_ignition_id    = module.ignition.master_ignition.id
  worker_ignition_id    = module.ignition.worker_ignition.id

  bootstrap_volume_id      = module.volumes.bootstrap_volume.id # ".id" es necesario para obtener el ID
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
