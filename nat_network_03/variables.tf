# variable.tf 
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
variable "coreos_image" {
  description = "URL of the Fedora CoreOS image"
  type        = string
  default     = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
}

variable "bootstrap_volume_size" {
  description = "Volume size for the bootstrap node in GiB"
  type        = number
  default     = 20  # Modify as required
}

variable "controlplane_1_volume_size" {
  description = "Volume size for the first control plane node in GiB"
  type        = number
  default     = 30  # Modify as required
}

variable "controlplane_2_volume_size" {
  description = "Volume size for the second control plane node in GiB"
  type        = number
  default     = 30  # Modify as required
}

variable "controlplane_3_volume_size" {
  description = "Volume size for the third control plane node in GiB"
  type        = number
  default     = 30  # Modify as required
}
