terraform {
  required_version = ">= 1.9.5"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Define storage pool for volumes
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
  # Ensure pool is created before using it
  lifecycle {
    create_before_destroy = true
  }
}

# Define node configurations with direct file URLs for Ignition files
locals {
  nodes = {
    bootstrap = { size = var.bootstrap_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/bootstrap.ign" },
    master1   = { size = var.master_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/master.ign" },
    master2   = { size = var.master_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/master.ign" },
    master3   = { size = var.master_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/master.ign" },
    worker1   = { size = var.worker_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/worker.ign" },
    worker2   = { size = var.worker_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/worker.ign" },
    worker3   = { size = var.worker_volume_size, file = "/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/worker.ign" }
  }
}

# Directly use local file paths without HTTP data source
resource "local_file" "ignition_files" {
  for_each = local.nodes
  content  = file(each.value.file)
  filename = "/tmp/${each.key}.ign"
}

# Create Ignition volumes for nodes
resource "libvirt_volume" "ignition_volumes" {
  for_each = local.nodes
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volumetmp_03.name
  source   = local_file.ignition_files[each.key].filename
  format   = "raw"
}

# Base volume definition for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  pool   = libvirt_pool.volumetmp_03.name
  source = var.coreos_image
  format = "qcow2"
}

# Create node volumes
resource "libvirt_volume" "okd_volumes" {
  for_each       = local.nodes
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volumetmp_03.name
  size           = each.value.size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Define libvirt domains for nodes
resource "libvirt_domain" "nodes" {
  for_each = local.nodes
  name     = each.key
  memory   = var.vm_definitions[each.key].memory
  vcpu     = var.vm_definitions[each.key].cpus

  # Use Ignition volume for cloud-init
  cloudinit = libvirt_volume.ignition_volumes[each.key].id

  network_interface {
    network_name = "nat_network_02"
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }
}

# Output node IP addresses
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}
