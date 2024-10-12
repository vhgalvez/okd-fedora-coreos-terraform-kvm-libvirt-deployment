# modules/volumes/main.tf
terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

# Volumen base para Fedora CoreOS
resource "libvirt_volume" "coreos_base" {
  name   = "fedora_coreos.qcow2"
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

# Volumen para Bootstrap
resource "libvirt_volume" "bootstrap_volume" {
  name           = "okd_bootstrap.qcow2"
  pool           = "default"
  size           = var.bootstrap_volume_size * 1073741824  # Convert GiB to Bytes
  base_volume_id = libvirt_volume.coreos_base.id
}

# Volumen para Control Plane 1
resource "libvirt_volume" "controlplane_1_volume" {
  name           = "okd_controlplane_1.qcow2"
  pool           = "default"
  size           = var.controlplane_1_volume_size * 1073741824
  base_volume_id = libvirt_volume.coreos_base.id
}

# Volumen para Control Plane 2
resource "libvirt_volume" "controlplane_2_volume" {
  name           = "okd_controlplane_2.qcow2"
  pool           = "default"
  size           = var.controlplane_2_volume_size * 1073741824
  base_volume_id = libvirt_volume.coreos_base.id
}

# Volumen para Control Plane 3
resource "libvirt_volume" "controlplane_3_volume" {
  name           = "okd_controlplane_3.qcow2"
  pool           = "default"
  size           = var.controlplane_3_volume_size * 1073741824
  base_volume_id = libvirt_volume.coreos_base.id
}

# Volumen para Worker 1
resource "libvirt_volume" "worker_1_volume" {
  name           = "okd_worker_1.qcow2"
  pool           = "default"
  size           = var.worker_1_volume_size * 1073741824
  base_volume_id = libvirt_volume.coreos_base.id
}

# Volumen para Worker 2
resource "libvirt_volume" "worker_2_volume" {
  name           = "okd_worker_2.qcow2"
  pool           = "default"
  size           = var.worker_2_volume_size * 1073741824
  base_volume_id = libvirt_volume.coreos_base.id
}

# Volumen para Worker 3
resource "libvirt_volume" "worker_3_volume" {
  name           = "okd_worker_3.qcow2"
  pool           = "default"
  size           = var.worker_3_volume_size * 1073741824
  base_volume_id = libvirt_volume.coreos_base.id
}

# Outputs for the volumes
output "bootstrap_volume" {
  value = libvirt_volume.bootstrap_volume.id
}

output "controlplane_1_volume" {
  value = libvirt_volume.controlplane_1_volume.id
}

output "controlplane_2_volume" {
  value = libvirt_volume.controlplane_2_volume.id
}

output "controlplane_3_volume" {
  value = libvirt_volume.controlplane_3_volume.id
}

output "worker_1_volume" {
  value = libvirt_volume.worker_1_volume.id
}

output "worker_2_volume" {
  value = libvirt_volume.worker_2_volume.id
}

output "worker_3_volume" {
  value = libvirt_volume.worker_3_volume.id
}
