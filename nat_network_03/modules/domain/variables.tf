# modules/domain/variables.tf


variable "bootstrap" {
  description = "Bootstrap node configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_1" {
  description = "Control Plane node 1 configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_2" {
  description = "Control Plane node 2 configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_3" {
  description = "Control Plane node 3 configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_1" {
  description = "Worker node 1 configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_2" {
  description = "Worker node 2 configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_3" {
  description = "Worker node 3 configuration"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}
