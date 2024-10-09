# variable.tf
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
