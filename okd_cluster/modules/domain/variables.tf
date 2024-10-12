# modules/domain/variables.tf

# Declare network_id variable
variable "network_id" {
  description = "ID of the network to which the nodes should be attached"
  type        = string
}

# Declare Ignition config ID variables
variable "bootstrap_ignition_id" {
  description = "Ignition configuration ID for the bootstrap node"
  type        = string
}

variable "master_ignition_id" {
  description = "Ignition configuration ID for control plane nodes"
  type        = string
}

variable "worker_ignition_id" {
  description = "Ignition configuration ID for worker nodes"
  type        = string
}

# Declare volume ID variables for each node type
variable "bootstrap_volume_id" {
  description = "Volume ID for the bootstrap node"
  type        = string
}

variable "controlplane_1_volume_id" {
  description = "Volume ID for control plane node 1"
  type        = string
}

variable "controlplane_2_volume_id" {
  description = "Volume ID for control plane node 2"
  type        = string
}

variable "controlplane_3_volume_id" {
  description = "Volume ID for control plane node 3"
  type        = string
}

variable "worker_1_volume_id" {
  description = "Volume ID for worker node 1"
  type        = string
}

variable "worker_2_volume_id" {
  description = "Volume ID for worker node 2"
  type        = string
}

variable "worker_3_volume_id" {
  description = "Volume ID for worker node 3"
  type        = string
}

# Declare node definitions for bootstrap, control planes, and workers
variable "bootstrap" {
  description = "Configuration for the bootstrap node"
  type        = map(string)
}

variable "controlplane_1" {
  description = "Configuration for control plane node 1"
  type        = map(string)
}

variable "controlplane_2" {
  description = "Configuration for control plane node 2"
  type        = map(string)
}

variable "controlplane_3" {
  description = "Configuration for control plane node 3"
  type        = map(string)
}

variable "worker_1" {
  description = "Configuration for worker node 1"
  type        = map(string)
}

variable "worker_2" {
  description = "Configuration for worker node 2"
  type        = map(string)
}

variable "worker_3" {
  description = "Configuration for worker node 3"
  type        = map(string)
}
