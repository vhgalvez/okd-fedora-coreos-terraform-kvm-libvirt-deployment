terraform {
  required_version = "= 1.9.6"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Create the network for the VMs
resource "libvirt_network" "br0" {
  name      = var.rocky9_network_name
  mode      = "nat"
  autostart = true
  addresses = ["10.17.3.0/24"]
}

# Create the storage pool for the VMs
resource "libvirt_pool" "volumetmp_bastion" {
  name = "${var.cluster_name}_bastion"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/${var.cluster_name}_bastion"
}

# Create the base volume (image) for the VMs
resource "libvirt_volume" "rocky9_image" {
  name   = "${var.cluster_name}_rocky9_image"
  source = var.rocky9_image
  pool   = libvirt_pool.volumetmp_bastion.name
  format = "qcow2"
}

# Create cloud-init configuration for the VMs
data "template_file" "vm_configs" {
  for_each = var.vm_rockylinux_definitions

  template = file("${path.module}/config/${each.key}-user-data.tpl")
  vars = {
    ssh_keys       = jsonencode(var.ssh_keys),
    hostname       = each.value.hostname,
    short_hostname = each.value.short_hostname,
    timezone       = var.timezone,
    ip             = each.value.ip,
    gateway        = each.value.gateway, # Use the correct reference
    dns1           = each.value.dns1,    # Use the correct reference
    dns2           = each.value.dns2     # Use the correct reference
  }
}

# Create the cloud-init disk for the VMs
resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  for_each = var.vm_rockylinux_definitions

  name      = "${each.key}_cloudinit.iso"
  pool      = libvirt_pool.volumetmp_bastion.name
  user_data = data.template_file.vm_configs[each.key].rendered
}

# Create the VM disks
resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_rockylinux_definitions

  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume.rocky9_image.id
  pool           = libvirt_pool.volumetmp_bastion.name
  format         = "qcow2"
}

# Create the VM domains
resource "libvirt_domain" "vm" {
  for_each = var.vm_rockylinux_definitions

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.cpus

  network_interface {
    network_id     = libvirt_network.br0.id
    wait_for_lease = true
    addresses      = [each.value.ip]
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.vm_cloudinit[each.key].id

  cpu {
    mode = "host-passthrough"
  }


  # Graphics support
  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  # Serial console support
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  # Destroy provisioner to clean up domain
  provisioner "local-exec" {
    when    = destroy
    command = "virsh undefine ${self.name} --remove-all-storage || true"
  }

  # Ensure proper destruction order
  depends_on = [
    libvirt_volume.vm_disk,
    libvirt_cloudinit_disk.vm_cloudinit
  ]
}

# Output the bastion IP address
output "bastion_ip_address" {
  value = var.vm_rockylinux_definitions["bastion1"].ip
}
