# outputs.tf

# Output para la IP del nodo bootstrap
output "bootstrap_ip" {
  value       = module.domain.okd_bootstrap
  description = "La IP del nodo bootstrap"
}

# Output para la IP del nodo master 1
output "master1_ip" {
  value       = module.domain.okd_controlplane_1
  description = "La IP del nodo master 1"
}

# Output para la IP del nodo master 2
output "master2_ip" {
  value       = module.domain.okd_controlplane_2
  description = "La IP del nodo master 2"
}

# Output para la IP del nodo master 3
output "master3_ip" {
  value       = module.domain.okd_controlplane_3
  description = "La IP del nodo master 3"
}

# Output para la IP del nodo worker 1
output "worker1_ip" {
  value       = module.domain.okd_worker_1
  description = "La IP del nodo worker 1"
}

# Output para la IP del nodo worker 2
output "worker2_ip" {
  value       = module.domain.okd_worker_2
  description = "La IP del nodo worker 2"
}

# Output para la IP del nodo worker 3
output "worker3_ip" {
  value       = module.domain.okd_worker_3
  description = "La IP del nodo worker 3"
}
