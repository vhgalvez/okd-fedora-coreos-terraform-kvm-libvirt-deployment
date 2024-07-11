variable "base_image" {
  description = "Path to the base VM image"
  type        = string
}

variable "vm_definitions" {
  description = "Definitions of virtual machines including CPU, memory, IP, and domain name"
  type = map(object({
    cpus         = number
    memory       = number
    ip           = string
    name_dominio = string
    disk_size    = number
  }))
}

variable "ssh_keys" {
  description = "List of SSH keys to inject into VMs"
  type        = list(string)
}

variable "gateway" {
  description = "Gateway IP address"
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

