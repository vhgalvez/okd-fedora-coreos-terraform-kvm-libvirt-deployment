# modules/volumes/variables.tf

 
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
