terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Define la pool de almacenamiento
resource "libvirt_pool" "volume_03" {
  name = "volume_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volume_03"

  lifecycle {
    create_before_destroy = true
  }
}

# Volumen base para Fedora CoreOS
resource "libvirt_volume" "fedora_coreos" {
  name   = "fedora_coreos.qcow2"
  pool   = libvirt_pool.volume_03.name
  source = var.coreos_image
  format = "qcow2"
}

# Volúmenes para cada nodo basado en el volumen base de Fedora CoreOS
resource "libvirt_volume" "okd_volumes" {
  for_each       = var.vm_definitions
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volume_03.name
  size           = each.value.disk_size * 1048576 # Convertir MB a bytes
  base_volume_id = libvirt_volume.fedora_coreos.id
}

# Crear archivo de Ignition para Bootstrap
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = libvirt_pool.volume_03.name
  content = file("${path.module}/ignition_configs/bootstrap.ign")
}

# Crear archivo de Ignition para Master
resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = libvirt_pool.volume_03.name
  content = file("${path.module}/ignition_configs/master.ign")
}

# Crear máquinas virtuales
resource "libvirt_domain" "nodes" {
  for_each = var.vm_definitions

  name   = "okd-${each.key}"
  memory = each.value.memory
  vcpu   = each.value.cpus

  # Conectar a la red
  network_interface {
    network_name   = "kube_network_02"
    mac            = each.value.mac
    addresses      = [each.value.ip]
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  qemu_agent = false
}

# Mostrar las direcciones IP de los nodos
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}
