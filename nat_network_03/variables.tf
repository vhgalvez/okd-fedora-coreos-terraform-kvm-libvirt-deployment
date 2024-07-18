variable "base_image" {
  description = "Path to the base VM image"
  type        = string
}

variable "vm_definitions" {
  description = "Definitions of virtual machines including CPU, memory, IP, domain name, and disk size"
  type = map(object({
    cpus         = number
    memory       = number
    ip           = string
    name_dominio = string
    disk_size    = number  # in MB
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

variable "kubelet_version" {
  description = "Version of Kubelet"
  type        = string
}

variable "kube_apiserver_version" {
  description = "Version of Kube-apiserver"
  type        = string
}

variable "etcd_version" {
  description = "Version of etcd"
  type        = string
}

variable "crio_version" {
  description = "Version of CRI-O"
  type        = string
}

variable "kube_controller_manager_version" {
  description = "Version of Kube-controller-manager"
  type        = string
}

variable "kube_scheduler_version" {
  description = "Version of Kube-scheduler"
  type        = string
}

variable "password_hash" {
  description = "Password hash for the root user"
  type        = string
}
