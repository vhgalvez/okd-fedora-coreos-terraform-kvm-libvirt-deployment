# modules/domain/variables.tf

# Declare network_name variable
variable "network_name" {
  description = "Name of the network to which the nodes should be attached"
  type        = string
}

# Declare Ignition config variables
variable "bootstrap_ignition" {
  description = "Ignition configuration for the bootstrap node"
  type        = string
}

variable "worker_ignition" {
  description = "Ignition configuration for worker nodes"
  type        = string
}

# Declare volume variables for each node type
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

# Declare node definitions for bootstrap, control planes, and workers
variable "bootstrap" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_1" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_2" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_3" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_1" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_2" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_3" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}
