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

# Define una nueva pool de almacenamiento
resource "libvirt_pool" "volume_03" {
  name = "volume_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volume_03"

  lifecycle {
    create_before_destroy = true
  }
}

# Define rutas locales a los archivos de Ignition
locals {
  ignition_files = {
    "bootstrap" = "${path.module}/okd-install/bootstrap.ign"
    "master1"   = "${path.module}/okd-install/master.ign"
    "master2"   = "${path.module}/okd-install/master.ign"
    "master3"   = "${path.module}/okd-install/master.ign"
    "worker1"   = "${path.module}/okd-install/worker.ign"
    "worker2"   = "${path.module}/okd-install/worker.ign"
    "worker3"   = "${path.module}/okd-install/worker.ign"
  }
}

# Crear volúmenes de Ignition
resource "libvirt_ignition" "ignitions" {
  for_each = local.ignition_files

  name    = "${each.key}-ignition"
  content = file(each.value)
}

# Crea un volumen base para Fedora CoreOS
resource "libvirt_volume" "coreos_image" {
  name   = "coreos_image.qcow2"
  pool   = libvirt_pool.volume_03.name
  source = var.coreos_image
  format = "qcow2"
}

# Crear volúmenes para cada nodo en base al volumen base
resource "libvirt_volume" "okd_volumes" {
  for_each       = var.vm_definitions
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volume_03.name
  size           = each.value.disk_size * 1048576 # Convertir MB a bytes
  base_volume_id = libvirt_volume.coreos_image.id
}

# Definir máquinas virtuales conectadas a la red existente "kube_network_02"
resource "libvirt_domain" "nodes" {
  for_each = var.vm_definitions

  name     = "okd-${each.key}"
  memory   = each.value.memory
  vcpu     = each.value.cpus

  # Usar el volumen de Ignition correcto
  cloudinit = libvirt_ignition.ignitions[each.key].id

  # Conectar las VMs a la red existente usando el nombre
  network_interface {
    network_name   = "kube_network_02"  # Referencia a la red existente
    wait_for_lease = true
  }

  # Agregar la IP estática según el archivo tfvars
  network_interface {
    network_name = "kube_network_02"
    addresses    = [each.value.ip]
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

  # Habilitar la comunicación con el agente QEMU para obtener IPs
  qemu_agent = true
}

# Mostrar las direcciones IP de los nodos
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}

