
# modules/volumes/main.tf
resource "libvirt_volume" "bootstrap_volume" {
  name           = "okd_bootstrap.qcow2"
  pool           = "default"
  size           = var.bootstrap_volume_size * 1073741824
  base_volume_id = var.coreos_base_volume
}

resource "libvirt_volume" "master_volume" {
  name           = "okd_master.qcow2"
  pool           = "default"
  size           = var.master_volume_size * 1073741824
  base_volume_id = var.coreos_base_volume
}

resource "libvirt_volume" "worker_volume" {
  name           = "okd_worker.qcow2"
  pool           = "default"
  size           = var.worker_volume_size * 1073741824
  base_volume_id = var.coreos_base_volume
}

# Outputs for the volumes
output "bootstrap_volume" {
  value = libvirt_volume.bootstrap_volume.id
}

output "master_volume" {
  value = libvirt_volume.master_volume.id
}

output "worker_volume" {
  value = libvirt_volume.worker_volume.id
}
