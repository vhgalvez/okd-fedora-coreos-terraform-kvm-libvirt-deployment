# modules/domain/main.tf
terraform {
  required_version = ">= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

# Bootstrap Node Definition
resource "libvirt_domain" "okd_bootstrap" {
  name            = var.bootstrap.name
  vcpu            = var.bootstrap.vcpu
  memory          = var.bootstrap.memory * 1024 # Convert memory from MiB
  running         = true
  coreos_ignition = var.bootstrap_ignition_id

  disk {
    volume_id = var.bootstrap_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.bootstrap.name
    addresses      = [var.bootstrap.address]
    mac            = var.bootstrap.mac
    wait_for_lease = true
  }
}

# Control Plane 1 Node Definition
resource "libvirt_domain" "okd_controlplane_1" {
  name            = var.controlplane_1.name
  vcpu            = var.controlplane_1.vcpu
  memory          = var.controlplane_1.memory * 1024
  running         = true
  coreos_ignition = var.master_ignition_id

  disk {
    volume_id = var.controlplane_1_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.controlplane_1.name
    addresses      = [var.controlplane_1.address]
    mac            = var.controlplane_1.mac
    wait_for_lease = true
  }
}

# Control Plane 2 Node Definition
resource "libvirt_domain" "okd_controlplane_2" {
  name            = var.controlplane_2.name
  vcpu            = var.controlplane_2.vcpu
  memory          = var.controlplane_2.memory * 1024
  running         = true
  coreos_ignition = var.master_ignition_id

  disk {
    volume_id = var.controlplane_2_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.controlplane_2.name
    addresses      = [var.controlplane_2.address]
    mac            = var.controlplane_2.mac
    wait_for_lease = true
  }
}

# Control Plane 3 Node Definition
resource "libvirt_domain" "okd_controlplane_3" {
  name            = var.controlplane_3.name
  vcpu            = var.controlplane_3.vcpu
  memory          = var.controlplane_3.memory * 1024
  running         = true
  coreos_ignition = var.master_ignition_id

  disk {
    volume_id = var.controlplane_3_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.controlplane_3.name
    addresses      = [var.controlplane_3.address]
    mac            = var.controlplane_3.mac
    wait_for_lease = true
  }
}

# Worker 1 Node Definition
resource "libvirt_domain" "okd_worker_1" {
  name            = var.worker_1.name
  vcpu            = var.worker_1.vcpu
  memory          = var.worker_1.memory * 1024
  running         = true
  coreos_ignition = var.worker_ignition_id

  disk {
    volume_id = var.worker_1_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.worker_1.name
    addresses      = [var.worker_1.address]
    mac            = var.worker_1.mac
    wait_for_lease = true
  }
}

# Worker 2 Node Definition
resource "libvirt_domain" "okd_worker_2" {
  name            = var.worker_2.name
  vcpu            = var.worker_2.vcpu
  memory          = var.worker_2.memory * 1024
  running         = true
  coreos_ignition = var.worker_ignition_id

  disk {
    volume_id = var.worker_2_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.worker_2.name
    addresses      = [var.worker_2.address]
    mac            = var.worker_2.mac
    wait_for_lease = true
  }
}

# Worker 3 Node Definition
resource "libvirt_domain" "okd_worker_3" {
  name            = var.worker_3.name
  vcpu            = var.worker_3.vcpu
  memory          = var.worker_3.memory * 1024
  running         = true
  coreos_ignition = var.worker_ignition_id

  disk {
    volume_id = var.worker_3_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
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

  network_interface {
    network_id     = var.network_id # Usa el UUID de la red
    hostname       = var.worker_3.name
    addresses      = [var.worker_3.address]
    mac            = var.worker_3.mac
    wait_for_lease = true
  }
}
