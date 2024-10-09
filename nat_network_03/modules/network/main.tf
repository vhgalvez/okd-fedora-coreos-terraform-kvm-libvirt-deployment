# modules/network/main.tf
resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  domain    = "okd.lab"
  addresses = ["192.168.150.0/24"]

  dns {
    enabled = true
  }
}


output "network_name" {
  value = libvirt_network.okd_network.name
}
