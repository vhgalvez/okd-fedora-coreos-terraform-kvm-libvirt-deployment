# Define the path to the CoreOS image
variable "coreos_image" {
  type        = string
  description = "Path to the CoreOS image"
}

# Define the size for the bootstrap node volume
variable "bootstrap_volume_size" {
  type        = number
  description = "Size of the bootstrap node volume in GiB"
}

# Define the size for the master node volumes
variable "master_volume_size" {
  type        = number
  description = "Size of the master node volumes in GiB"
}

# Define the size for the worker node volumes
variable "worker_volume_size" {
  type        = number
  description = "Size of the worker node volumes in GiB"
}
