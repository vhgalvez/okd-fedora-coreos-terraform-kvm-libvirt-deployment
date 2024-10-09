terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

# Define the network
resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  domain    = "okd.lab"
  addresses = ["192.168.150.0/24"]

  dns {
    enabled = true
  }
}

# Output the network ID for other modules to reference
output "network_id" {
  value = libvirt_network.okd_network.id
}

# Optionally, keep the network name output if needed
output "network_name" {
  value = libvirt_network.okd_network.name
}
