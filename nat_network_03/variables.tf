# variable.tf
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
}

variable "bootstrap_volume_size" {
  description = "Volume size for bootstrap node (in GiB)"
  type        = number
}

variable "master_volume_size" {
  description = "Volume size for master nodes (in GiB)"
  type        = number
}

variable "worker_volume_size" {
  description = "Volume size for worker nodes (in GiB)"
  type        = number
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
