# modules/volumes/variables.tf

variable "coreos_image" {
  description = "Path to the CoreOS image"
  type        = string
}

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
