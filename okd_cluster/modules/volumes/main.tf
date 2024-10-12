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
  name = "bootstrap-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/bootstrap.qcow2"
  size = 20 * 1024 * 1024 * 1024 # 20 GB
}

# Control Plane 1 Volume Definition
resource "libvirt_volume" "controlplane_1_volume" {
  name = "controlplane1-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/controlplane1.qcow2"
  size = 30 * 1024 * 1024 * 1024 # 30 GB
}

# Control Plane 2 Volume Definition
resource "libvirt_volume" "controlplane_2_volume" {
  name = "controlplane2-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/controlplane2.qcow2"
  size = 30 * 1024 * 1024 * 1024 # 30 GB
}

# Control Plane 3 Volume Definition
resource "libvirt_volume" "controlplane_3_volume" {
  name = "controlplane3-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/controlplane3.qcow2"
  size = 30 * 1024 * 1024 * 1024 # 30 GB
}

# Worker 1 Volume Definition
resource "libvirt_volume" "worker_1_volume" {
  name = "worker1-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/worker1.qcow2"
  size = 30 * 1024 * 1024 * 1024 # 30 GB
}

# Worker 2 Volume Definition
resource "libvirt_volume" "worker_2_volume" {
  name = "worker2-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/worker2.qcow2"
  size = 30 * 1024 * 1024 * 1024 # 30 GB
}

# Worker 3 Volume Definition
resource "libvirt_volume" "worker_3_volume" {
  name = "worker3-volume"
  pool = "default"
  path = "/mnt/lv_data/organized_storage/volumes/okd_cluster/worker3.qcow2"
  size = 30 * 1024 * 1024 * 1024 # 30 GB
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
