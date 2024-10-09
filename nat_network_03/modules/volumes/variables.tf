# modules/volumes/variables.tf

# Declare CoreOS image variable
variable "coreos_image" {
  description = "Path to the CoreOS image"
  type        = string
}

# Declare volume size variables for each node type

variable "bootstrap_volume_size" {
  description = "Size of the bootstrap node volume in GiB"
  type        = number
}

variable "controlplane_1_volume_size" {
  description = "Size of the control plane node 1 volume in GiB"
  type        = number
}

variable "controlplane_2_volume_size" {
  description = "Size of the control plane node 2 volume in GiB"
  type        = number
}

variable "controlplane_3_volume_size" {
  description = "Size of the control plane node 3 volume in GiB"
  type        = number
}

variable "worker_1_volume_size" {
  description = "Size of the worker node 1 volume in GiB"
  type        = number
}

variable "worker_2_volume_size" {
  description = "Size of the worker node 2 volume in GiB"
  type        = number
}

variable "worker_3_volume_size" {
  description = "Size of the worker node 3 volume in GiB"
  type        = number
}
