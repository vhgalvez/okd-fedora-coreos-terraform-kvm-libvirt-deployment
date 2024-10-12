# modules/network/main.tf
terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

# No se crea una nueva red, ya que la red kube_network_02 está creada
output "network_name" {
  value = "kube_network_02"
}
