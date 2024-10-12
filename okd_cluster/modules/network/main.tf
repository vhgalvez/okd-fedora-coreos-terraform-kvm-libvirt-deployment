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

# Salida para devolver el network_name
output "network_name" {
  value = "kube_network_02" # El nombre de la red existente
}
