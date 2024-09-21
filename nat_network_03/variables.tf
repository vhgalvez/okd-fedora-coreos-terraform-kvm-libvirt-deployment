variable "base_image" {
  description = "Path to the Fedora CoreOS base image"
  type        = string
}

variable "vm_definitions" {
  description = "Virtual machine definitions including CPU, memory, IP, and disk size"
  type = map(object({
    cpus         = number
    memory       = number
    ip           = string
    name_dominio = string
    disk_size    = number
    node_name    = string
  }))
}

variable "ssh_keys" {
  description = "SSH keys for VM access"
  type        = list(string)
}

variable "gateway" {
  description = "Gateway for the network"
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

variable "initial_cluster" {
  description = "Initial cluster configuration for etcd"
  type        = string
}
