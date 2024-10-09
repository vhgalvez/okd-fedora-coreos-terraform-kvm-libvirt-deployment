variable "network_name" {
  type = string
  description = "Name of the network to attach the domains"
}

variable "bootstrap_ignition" {
  type = string
  description = "Ignition config for the bootstrap node"
}

variable "master_ignition" {
  type = string
  description = "Ignition config for the control plane nodes"
}

variable "worker_ignition" {
  type = string
  description = "Ignition config for the worker nodes"
}

variable "bootstrap_volume" {
  type = string
  description = "Volume ID for the bootstrap node"
}

variable "master_volume" {
  type = string
  description = "Volume ID for the master nodes"
}

variable "worker_volume" {
  type = string
  description = "Volume ID for the worker nodes"
}

variable "bootstrap" {
  type = map(any)
  description = "Configuration for the bootstrap node"
}

variable "controlplane_1" {
  type = map(any)
  description = "Configuration for the first control plane node"
}

variable "controlplane_2" {
  type = map(any)
  description = "Configuration for the second control plane node"
}

variable "controlplane_3" {
  type = map(any)
  description = "Configuration for the third control plane node"
}

variable "worker_1" {
  type = map(any)
  description = "Configuration for the first worker node"
}

variable "worker_2" {
  type = map(any)
  description = "Configuration for the second worker node"
}

variable "worker_3" {
  type = map(any)
  description = "Configuration for the third worker node"
}