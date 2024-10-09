# modules/ignition/main.tf

terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

# Bootstrap Ignition Configuration
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/bootstrap.ign")
}

# Control Plane Ignition Configuration (renamed from master)
resource "libvirt_ignition" "controlplane_ignition" {
  name    = "okd_controlplane.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/master.ign")
}

# Worker Ignition Configuration
resource "libvirt_ignition" "worker_ignition" {
  name    = "okd_worker.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/worker.ign")
}

# Outputs for the Ignition configurations
output "bootstrap_ignition" {
  value = libvirt_ignition.bootstrap_ignition.id
}

output "controlplane_ignition" {
  value = libvirt_ignition.controlplane_ignition.id
}

output "worker_ignition" {
  value = libvirt_ignition.worker_ignition.id
}
