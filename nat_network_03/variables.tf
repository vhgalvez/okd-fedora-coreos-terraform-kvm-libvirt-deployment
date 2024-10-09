# Declare volume size for each worker node
variable "worker_1_volume_size" {
  description = "Size of the worker 1 node volume in GiB"
  type        = number
}

variable "worker_2_volume_size" {
  description = "Size of the worker 2 node volume in GiB"
  type        = number
}

variable "worker_3_volume_size" {
  description = "Size of the worker 3 node volume in GiB"
  type        = number
}

variable "dns1" {
  type        = string
  description = "Primary DNS server"
}

variable "dns2" {
  type        = string
  description = "Secondary DNS server"
}

variable "gateway" {
  type        = string
  description = "Gateway for the network"
}

variable "bootstrap_volume_size" {
  type        = number
  description = "Size of the bootstrap node volume in GiB"
}

variable "controlplane_1_volume_size" {
  type        = number
  description = "Size of the control plane node 1 volume in GiB"
}

variable "controlplane_2_volume_size" {
  type        = number
  description = "Size of the control plane node 2 volume in GiB"
}

variable "controlplane_3_volume_size" {
  type        = number
  description = "Size of the control plane node 3 volume in GiB"
}

variable "worker_volume_size" {
  type        = number
  description = "Size of the worker node volume in GiB"
}

variable "coreos_image" {
  type        = string
  description = "Path to the CoreOS image"
}

variable "bootstrap" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Bootstrap node definition"
}

variable "controlplane_1" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Control plane node 1 definition"
}

variable "controlplane_2" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Control plane node 2 definition"
}

variable "controlplane_3" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Control plane node 3 definition"
}

variable "worker_1" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Worker node 1 definition"
}

variable "worker_2" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Worker node 2 definition"
}

variable "worker_3" {
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
  description = "Worker node 3 definition"
}
