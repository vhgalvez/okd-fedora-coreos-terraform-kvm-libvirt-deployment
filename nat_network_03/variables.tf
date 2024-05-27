# nat_network_03/variables.tf
variable "base_image" {
  description = "Path to the base VM image"
  type        = string
}

variable "vm_definitions" {
  description = "Definitions of virtual machines including CPU and memory configuration"
  type = map(object({
    cpus   = number
    memory = number
    ip     = string

  }))
}

variable "ssh_keys" {
  description = "List of SSH keys to inject into VMs"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_domain" {
  description = "Domain name of the cluster"
  type        = string
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