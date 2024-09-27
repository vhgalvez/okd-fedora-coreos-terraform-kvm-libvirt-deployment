variable "coreos_image" {
  description = "URL for Fedora CoreOS image"
  type        = string
  default     = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
}

variable "bootstrap_volume_size" {
  description = "Volume size for bootstrap node (in GiB)"
  type        = number
  default     = 20
}

variable "master_volume_size" {
  description = "Volume size for master nodes (in GiB)"
  type        = number
  default     = 30
}

variable "worker_volume_size" {
  description = "Volume size for worker nodes (in GiB)"
  type        = number
  default     = 30
}

variable "vm_definitions" {
  description = "VM configurations"
  type = map(object({
    cpus   = number
    memory = number
  }))
}

variable "gateway" {
  description = "Network gateway"
  type        = string
}

variable "dns1" {
  description = "Primary DNS server"
  type        = string
}

variable "dns2" {
  description = "Secondary DNS server"
  type        = string
}
variable "base_image" {
  description = "Path to the base image for the VM"
  type        = string
}
