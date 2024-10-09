variable "network_name" {
  description = "Name of the network"
  type        = string
}

variable "bootstrap_ignition" {
  description = "Ignition config for the bootstrap node"
  type        = string
}

variable "master_ignition" {
  description = "Ignition config for the master nodes"
  type        = string
}

variable "worker_ignition" {
  description = "Ignition config for the worker nodes"
  type        = string
}
