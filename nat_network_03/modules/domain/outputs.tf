# modules/domain/outputs.tf

output "okd_bootstrap_ip" {
  value = libvirt_domain.okd_bootstrap.network_interface.0.addresses[0]
}

output "okd_controlplane_1_ip" {
  value = libvirt_domain.okd_controlplane_1.network_interface.0.addresses[0]
}

output "okd_controlplane_2_ip" {
  value = libvirt_domain.okd_controlplane_2.network_interface.0.addresses[0]
}

output "okd_controlplane_3_ip" {
  value = libvirt_domain.okd_controlplane_3.network_interface.0.addresses[0]
}

output "okd_worker_1_ip" {
  value = libvirt_domain.okd_worker_1.network_interface.0.addresses[0]
}

output "okd_worker_2_ip" {
  value = libvirt_domain.okd_worker_2.network_interface.0.addresses[0]
}

output "okd_worker_3_ip" {
  value = libvirt_domain.okd_worker_3.network_interface.0.addresses[0]
}
