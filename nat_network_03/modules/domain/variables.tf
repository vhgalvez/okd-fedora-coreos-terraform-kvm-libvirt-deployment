variable "bootstrap_volume" {
  description = "Volume ID for the bootstrap node"
  type        = string
}

variable "controlplane_1_volume" {
  description = "Volume ID for control plane node 1"
  type        = string
}

variable "controlplane_2_volume" {
  description = "Volume ID for control plane node 2"
  type        = string
}

variable "controlplane_3_volume" {
  description = "Volume ID for control plane node 3"
  type        = string
}

variable "worker_1_volume" {
  description = "Volume ID for worker node 1"
  type        = string
}

variable "worker_2_volume" {
  description = "Volume ID for worker node 2"
  type        = string
}

variable "worker_3_volume" {
  description = "Volume ID for worker node 3"
  type        = string
}

variable "network_name" {
  description = "Name of the libvirt network"
  type        = string
}

variable "bootstrap_ignition" {
  description = "Ignition ID for bootstrap node"
  type        = string
}

variable "master_ignition" {
  description = "Ignition ID for master nodes"
  type        = string
}

variable "worker_ignition" {
  description = "Ignition ID for worker nodes"
  type        = string
}
