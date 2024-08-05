provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
  dhcp {
    enabled = true
  }
}

resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/var/lib/libvirt/images/volumetmp_03"
}

resource "libvirt_volume" "base" {
  name   = "base"
  source = var.base_image
  pool   = libvirt_pool.volumetmp_03.name
  format = "qcow2"
}

resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_definitions

  name           = "${each.key}-disk"
  base_volume_id = libvirt_volume.base.id
  pool           = libvirt_pool.volumetmp_03.name
  format         = "qcow2"
  size           = each.value.disk_size * 1024 * 1024 # size in MB converted to bytes
}

resource "libvirt_domain" "machine" {
  for_each = var.vm_definitions

  name   = each.key
  vcpu   = each.value.cpus
  memory = each.value.memory

  network_interface {
    network_id     = libvirt_network.kube_network_03.id
    wait_for_lease = true
    addresses      = [each.value.ip]
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  coreos_ignition {
    url = "http://10.17.3.14/okd/${each.key}.ign"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  qemu_agent = true
}

output "ip_addresses" {
  value = { for key, machine in libvirt_domain.machine : key => machine.network_interface[0].addresses[0] if length(machine.network_interface[0].addresses) > 0 }
}
