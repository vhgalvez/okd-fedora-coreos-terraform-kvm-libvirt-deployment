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


resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/bootstrap.ign")
}

resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/master.ign")
}

resource "libvirt_ignition" "worker_ignition" {
  name    = "okd_worker.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/worker.ign")
}

# Outputs to be used by the domain module
output "bootstrap_ignition" {
  value = libvirt_ignition.bootstrap_ignition.id
}

output "master_ignition" {
  value = libvirt_ignition.master_ignition.id
}

output "worker_ignition" {
  value = libvirt_ignition.worker_ignition.id
}