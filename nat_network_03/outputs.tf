# outputs.tf
output "bootstrap_ip" {
  value = module.domain.okd_bootstrap_ip
}

output "controlplane_1_ip" {
  value = module.domain.okd_controlplane_1_ip
}

output "controlplane_2_ip" {
  value = module.domain.okd_controlplane_2_ip
}

output "controlplane_3_ip" {
  value = module.domain.okd_controlplane_3_ip
}

output "worker_1_ip" {
  value = module.domain.okd_worker_1_ip
}

output "worker_2_ip" {
  value = module.domain.okd_worker_2_ip
}

output "worker_3_ip" {
  value = module.domain.okd_worker_3_ip
}
