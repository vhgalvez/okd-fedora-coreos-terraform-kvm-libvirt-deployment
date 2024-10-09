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

# Red de OKD
resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  domain    = "okd.lab"
  addresses = ["192.168.150.0/24"]
}

# Volumen base para Fedora CoreOS
resource "libvirt_volume" "fedora_coreos" {
  name   = "fedora_coreos.qcow2"
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

# Ignition para los nodos
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = file("${path.module}/ignition_configs/bootstrap.ign")
}

resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = "default"
  content = file("${path.module}/ignition_configs/master.ign")
}

resource "libvirt_ignition" "worker_ignition" {
  name    = "okd_worker.ign"
  pool    = "default"
  content = file("${path.module}/ignition_configs/worker.ign")
}

# Volúmenes para cada nodo
resource "libvirt_volume" "bootstrap_volume" {
  name           = "okd_bootstrap.qcow2"
  pool           = "default"
  size           = var.bootstrap.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "controlplane_1_volume" {
  name           = "okd_controlplane_1.qcow2"
  pool           = "default"
  size           = var.controlplane_1.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "controlplane_2_volume" {
  name           = "okd_controlplane_2.qcow2"
  pool           = "default"
  size           = var.controlplane_2.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "controlplane_3_volume" {
  name           = "okd_controlplane_3.qcow2"
  pool           = "default"
  size           = var.controlplane_3.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "worker_1_volume" {
  name           = "okd_worker1.qcow2"
  pool           = "default"
  size           = var.worker_1.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "worker_2_volume" {
  name           = "okd_worker2.qcow2"
  pool           = "default"
  size           = var.worker_2.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "worker_3_volume" {
  name           = "okd_worker3.qcow2"
  pool           = "default"
  size           = var.worker_3.volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

# Definir máquinas virtuales para los nodos
resource "libvirt_domain" "okd_bootstrap" {
  name            = var.bootstrap.name
  memory          = var.bootstrap.memory * 1024 # MiB
  vcpu            = var.bootstrap.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.bootstrap_ignition.id

  disk {
    volume_id = libvirt_volume.bootstrap_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.bootstrap.name
    addresses      = [var.bootstrap.address]
    mac            = var.bootstrap.mac
  }
}

resource "libvirt_domain" "okd_controlplane_1" {
  name            = var.controlplane_1.name
  memory          = var.controlplane_1.memory * 1024 # MiB
  vcpu            = var.controlplane_1.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.master_ignition.id

  disk {
    volume_id = libvirt_volume.controlplane_1_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.controlplane_1.name
    addresses      = [var.controlplane_1.address]
    mac            = var.controlplane_1.mac
  }
}

resource "libvirt_domain" "okd_controlplane_2" {
  name            = var.controlplane_2.name
  memory          = var.controlplane_2.memory * 1024 # MiB
  vcpu            = var.controlplane_2.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.master_ignition.id

  disk {
    volume_id = libvirt_volume.controlplane_2_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.controlplane_2.name
    addresses      = [var.controlplane_2.address]
    mac            = var.controlplane_2.mac
  }
}

resource "libvirt_domain" "okd_controlplane_3" {
  name            = var.controlplane_3.name
  memory          = var.controlplane_3.memory * 1024 # MiB
  vcpu            = var.controlplane_3.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.master_ignition.id

  disk {
    volume_id = libvirt_volume.controlplane_3_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.controlplane_3.name
    addresses      = [var.controlplane_3.address]
    mac            = var.controlplane_3.mac
  }
}

resource "libvirt_domain" "okd_worker_1" {
  name            = var.worker_1.name
  memory          = var.worker_1.memory * 1024 # MiB
  vcpu            = var.worker_1.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.worker_ignition.id

  disk {
    volume_id = libvirt_volume.worker_1_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.worker_1.name
    addresses      = [var.worker_1.address]
    mac            = var.worker_1.mac
  }
}

resource "libvirt_domain" "okd_worker_2" {
  name            = var.worker_2.name
  memory          = var.worker_2.memory * 1024 # MiB
  vcpu            = var.worker_2.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.worker_ignition.id

  disk {
    volume_id = libvirt_volume.worker_2_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.worker_2.name
    addresses      = [var.worker_2.address]
    mac            = var.worker_2.mac
  }
}

resource "libvirt_domain" "okd_worker_3" {
  name            = var.worker_3.name
  memory          = var.worker_3.memory * 1024 # MiB
  vcpu            = var.worker_3.vcpu
  running         = true
  coreos_ignition = libvirt_ignition.worker_ignition.id

  disk {
    volume_id = libvirt_volume.worker_3_volume.id
  }

  network_interface {
    network_name   = libvirt_network.okd_network.name
    hostname       = var.worker_3.name
    addresses      = [var.worker_3.address]
    mac            = var.worker_3.mac
  }
}

# Output de direcciones IP
output "node_ips" {
  value = {
    bootstrap      = libvirt_domain.okd_bootstrap.network_interface[0].addresses[0]
    controlplane_1 = libvirt_domain.okd_controlplane_1.network_interface[0].addresses[0]
    controlplane_2 = libvirt_domain.okd_controlplane_2.network_interface[0].addresses[0]
    controlplane_3 = libvirt_domain.okd_controlplane_3.network_interface[0].addresses[0]
    worker_1       = libvirt_domain.okd_worker_1.network_interface[0].addresses[0]
    worker_2       = libvirt_domain.okd_worker_2.network_interface[0].addresses[0]
    worker_3       = libvirt_domain.okd_worker_3.network_interface[0].addresses[0]
  }

  