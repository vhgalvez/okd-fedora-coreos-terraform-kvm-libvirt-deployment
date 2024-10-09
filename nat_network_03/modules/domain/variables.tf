variable "bootstrap_volume" {
  description = "Volume ID for the bootstrap node"
  type        = string
}

variable "controlplane_1_volume" {
  description = "Volume ID for Control Plane 1"
  type        = string
}

variable "controlplane_2_volume" {
  description = "Volume ID for Control Plane 2"
  type        = string
}

variable "controlplane_3_volume" {
  description = "Volume ID for Control Plane 3"
  type        = string
}

variable "worker_1_volume" {
  description = "Volume ID for Worker 1"
  type        = string
}

variable "worker_2_volume" {
  description = "Volume ID for Worker 2"
  type        = string
}

variable "worker_3_volume" {
  description = "Volume ID for Worker 3"
  type        = string
}
