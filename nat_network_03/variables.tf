# variables.tf
variable "base_image" {
  description = "The path to the base image"
  type        = string
}

variable "vm_definitions" {
  description = "A map of VM definitions"
  type        = map(object({
    name_dominio = string
    ip           = string
    cpus         = number
    memory       = number
    disk_size    = number
  }))
}