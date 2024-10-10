terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

# Definir la red
resource "libvirt_network" "okd_network" {
  name      = "okd_network"       # Nombre de la red
  mode      = "nat"               # Usar modo NAT
  domain    = "okd.lab"           # Dominio de la red
  addresses = ["192.168.150.0/24"] # Dirección CIDR para la red

  dns {
    enabled = true                # Habilitar DNS en la red
  }
}

# Output del UUID de la red para utilizarlo en otros módulos
output "network_id" {
  value = libvirt_network.okd_network.id # Exporta el UUID de la red
}

# Output opcional para exportar el nombre de la red (si es necesario en otros módulos)
output "network_name" {
  value = libvirt_network.okd_network.name # Exporta el nombre de la red
}
