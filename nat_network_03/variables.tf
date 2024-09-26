variable "coreos_image" {
  description = "URL or path to Fedora CoreOS image"
  type        = string
  default     = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
}

variable "bootstrap_volume_size" {
  description = "Size of the bootstrap volume in GiB"
  type        = number
  default     = 20  # Modify as required
}

variable "controlplane_1_volume_size" {
  description = "Size of the control plane volume 1 in GiB"
  type        = number
  default     = 30  # Modify as required
}

variable "controlplane_2_volume_size" {
  description = "Size of the control plane volume 2 in GiB"
  type        = number
  default     = 30  # Modify as required
}

variable "controlplane_3_volume_size" {
  description = "Size of the control plane volume 3 in GiB"
  type        = number
  default     = 30  # Modify as required
}
