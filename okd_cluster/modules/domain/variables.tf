# modules/domain/variables.tf

# Variable para network_name
variable "network_name" {
  description = "Nombre de la red a la que los nodos deben estar conectados"
  type        = string
}

# Variables para Ignition Config IDs
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

# Variables para los volúmenes de los nodos
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

# Variables para los nodos (Bootstrap, Control Plane y Worker)
variable "bootstrap" {
  description = "Configuration for the bootstrap node"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_1" {
  description = "Configuration for control plane node 1"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_2" {
  description = "Configuration for control plane node 2"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "controlplane_3" {
  description = "Configuration for control plane node 3"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_1" {
  description = "Configuration for worker node 1"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_2" {
  description = "Configuration for worker node 2"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "worker_3" {
  description = "Configuration for worker node 3"
  type = object({
    name    = string
    memory  = number
    vcpu    = number
    address = string
    mac     = string
  })
}

variable "coreos_image" {
  description = "Path to the CoreOS image"
  type        = string
}
