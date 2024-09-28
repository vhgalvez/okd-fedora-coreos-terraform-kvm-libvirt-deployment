
# Variables for the NAT network module
variable "initial_cluster" {
  description = "Initial cluster configuration for VM nodes"
  type        = string
}

# Variables for the NAT network module
variable "gateway" {
  description = "Gateway IP address for network routing"
  type        = string
}

# Primary DNS server

variable "dns1" {
  description = "Primary DNS server"
  type        = string
}

# Secondary DNS server
variable "dns2" {
  description = "Secondary DNS server"
  type        = string
}

# Path to the Fedora CoreOS base image
variable "base_image" {
  description = "Path to the Fedora CoreOS base image"
  type        = string
}

# Volume size for bootstrap node (in GiB)
variable "bootstrap_volume_size" {
  description = "Volume size for bootstrap node (in GiB)"
  type        = number
}

# Volume size for master nodes (in GiB)
variable "master_volume_size" {
  description = "Volume size for master nodes (in GiB)"
  type        = number
}

# Volume size for worker nodes (in GiB)
variable "worker_volume_size" {
  description = "Volume size for worker nodes (in GiB)"
  type        = number
}

# VM configurations including CPU, memory, disk size, and network info
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

# List of SSH public keys
variable "ssh_keys" {
  description = "List of SSH public keys"
  type        = list(string)
}
