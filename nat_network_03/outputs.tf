output "bootstrap_ip" {
  description = "IP address of the Bootstrap node"
  value = module.domain.okd_bootstrap.network_interface.0.addresses[0]
}

output "controlplane_1_ip" {
  description = "IP address of Control Plane node 1"
  value = module.domain.okd_controlplane_1.network_interface.0.addresses[0]
}

output "controlplane_2_ip" {
  description = "IP address of Control Plane node 2"
  value = module.domain.okd_controlplane_2.network_interface.0.addresses[0]
}

output "controlplane_3_ip" {
  description = "IP address of Control Plane node 3"
  value = module.domain.okd_controlplane_3.network_interface.0.addresses[0]
}

output "worker_1_ip" {
  description = "IP address of Worker node 1"
  value = module.domain.okd_worker_1.network_interface.0.addresses[0]
}

output "worker_2_ip" {
  description = "IP address of Worker node 2"
  value = module.domain.okd_worker_2.network_interface.0.addresses[0]
}

output "worker_3_ip" {
  description = "IP address of Worker node 3"
  value = module.domain.okd_worker_3.network_interface.0.addresses[0]
}
