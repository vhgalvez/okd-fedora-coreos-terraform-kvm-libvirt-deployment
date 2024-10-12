# outputs.tf
output "bootstrap" {
  value = module.domain.okd_bootstrap
}

output "controlplane_1" {
  value = module.domain.okd_controlplane_1
}

output "controlplane_2" {
  value = module.domain.okd_controlplane_2
}

output "controlplane_3" {
  value = module.domain.okd_controlplane_3
}

output "worker_1" {
  value = module.domain.okd_worker_1
}

output "worker_2" {
  value = module.domain.okd_worker_2
}

output "worker_3" {
  value = module.domain.okd_worker_3
}
