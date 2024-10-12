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

# Bootstrap Volume
resource "libvirt_volume" "bootstrap_volume" {
  name   = "okd_bootstrap"
  pool   = "default"
  source = var.coreos_image
  # size  = var.bootstrap_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}

# Control Plane 1 Volume
resource "libvirt_volume" "controlplane_1_volume" {
  name   = "okd_controlplane_1"
  pool   = "default"
  source = var.coreos_image
  # size  = var.controlplane_1_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}

# Control Plane 2 Volume
resource "libvirt_volume" "controlplane_2_volume" {
  name   = "okd_controlplane_2"
  pool   = "default"
  source = var.coreos_image
  # size  = var.controlplane_2_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}

# Control Plane 3 Volume
resource "libvirt_volume" "controlplane_3_volume" {
  name   = "okd_controlplane_3"
  pool   = "default"
  source = var.coreos_image
  # size  = var.controlplane_3_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}

# Worker 1 Volume
resource "libvirt_volume" "worker_1_volume" {
  name   = "okd_worker_1"
  pool   = "default"
  source = var.coreos_image
  # size  = var.worker_1_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}

# Worker 2 Volume
resource "libvirt_volume" "worker_2_volume" {
  name   = "okd_worker_2"
  pool   = "default"
  source = var.coreos_image
  # size  = var.worker_2_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}

# Worker 3 Volume
resource "libvirt_volume" "worker_3_volume" {
  name   = "okd_worker_3"
  pool   = "default"
  source = var.coreos_image
  # size  = var.worker_3_volume_size  # Este parámetro se elimina porque hay una imagen de origen
}
