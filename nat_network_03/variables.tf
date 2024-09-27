variable "dns1" {
  description = "Primary DNS server"
  type        = string
}

variable "dns2" {
  description = "Secondary DNS server"
  type        = string
}

variable "gateway" {
  description = "Network gateway"
  type        = string
}

variable "ssh_keys" {
  description = "List of SSH public keys"
  type        = list(string)
}
variable "coreos_image" {
  description = "URL or path to the Fedora CoreOS image"
  type        = string
}
