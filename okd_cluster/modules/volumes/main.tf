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

provider "libvirt" {
  uri = "qemu:///system"
}


# Bootstrap Volume Definition
resource "libvirt_volume" "bootstrap_volume" {
  name   = "bootstrap-volume"
  pool   = "default"
  source = var.coreos_image
}

# Control Plane 1 Volume Definition
resource "libvirt_volume" "controlplane_1_volume" {
  name   = "controlplane1-volume"
  pool   = "default"
  source = var.coreos_image
}

# Control Plane 2 Volume Definition
resource "libvirt_volume" "controlplane_2_volume" {
  name   = "controlplane2-volume"
  pool   = "default"
  source = var.coreos_image
}

# Control Plane 3 Volume Definition
resource "libvirt_volume" "controlplane_3_volume" {
  name   = "controlplane3-volume"
  pool   = "default"
  source = var.coreos_image
}

# Worker 1 Volume Definition
resource "libvirt_volume" "worker_1_volume" {
  name   = "worker1-volume"
  pool   = "default"
  source = var.coreos_image
}

# Worker 2 Volume Definition
resource "libvirt_volume" "worker_2_volume" {
  name   = "worker2-volume"
  pool   = "default"
  source = var.coreos_image
}

# Worker 3 Volume Definition
resource "libvirt_volume" "worker_3_volume" {
  name   = "worker3-volume"
  pool   = "default"
  source = var.coreos_image
}

# modules/volumes/outputs.tf

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
