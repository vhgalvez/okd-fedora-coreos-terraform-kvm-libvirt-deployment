variable "dns1" {
  description = "Primary DNS server"
  type        = string
}

variable "dns2" {
  description = "Secondary DNS server"
  type        = string
}

variable "coreos_image" {
  description = "Path to the Fedora CoreOS base image"
  type        = string
  default     = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"
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
  description = "VM configurations including CPU, memory, disk size, and network info"
  type = map(object({
    cpus         = number
    memory       = number
    disk_size    = number
    ip           = string
    name_dominio = string
    node_name    = string
  }))
}

variable "ssh_keys" {
  description = "List of SSH public keys"
  type        = list(string)
}
