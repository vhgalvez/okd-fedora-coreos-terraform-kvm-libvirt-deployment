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

output "network_id" {
  value = libvirt_network.okd_network.id 
}

output "network_name" {
  value = libvirt_network.okd_network.name 
}
