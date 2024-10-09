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

variable "coreos_image" {
  type        = string
  description = "Path to the CoreOS image"
}

variable "bootstrap_volume_size" {
  type        = number
  description = "Size of the bootstrap node volume in GiB"
}

variable "master_volume_size" {
  type        = number
  description = "Size of the master node volume in GiB"
}

variable "worker_volume_size" {
  type        = number
  description = "Size of the worker node volume in GiB"
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

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH public keys"
}
