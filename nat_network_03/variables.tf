# variables.tf

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

# Define the volume sizes for control plane nodes
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

# Define the volume sizes for worker nodes
variable "worker_1_volume_size" {
  type        = number
  description = "Size of the worker node 1 volume in GiB"
}

variable "worker_2_volume_size" {
  type        = number
  description = "Size of the worker node 2 volume in GiB"
}

variable "worker_3_volume_size" {
  type        = number
  description = "Size of the worker node 3 volume in GiB"
}

variable "vm_definitions" {
  type = map(object({
    cpus         = number
    memory       = number
    ip           = string
    name_dominio = string
    mac          = string
    disk_size    = number
  }))
}

variable "coreos_image" {
  description = "Path to the CoreOS image"
  type        = string
}
