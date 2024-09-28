terraform {
  required_version = ">= 1.9.5"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
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

# Definir el pool de almacenamiento para los volúmenes
resource "libvirt_pool" "volumetmp_03" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  lifecycle {
    create_before_destroy = true
  }
}

# Crear directorio para el pool de almacenamiento si no existe
resource "null_resource" "create_pool_directory" {
  provisioner "local-exec" {
    command = "mkdir -p /mnt/lv_data/organized_storage/volumes/volumetmp_03"
  }

  provisioner "local-exec" {
    command = "chown -R libvirt-qemu:kvm /mnt/lv_data/organized_storage/volumes/volumetmp_03"
  }

  provisioner "local-exec" {
    command = "chcon -t svirt_home_t /mnt/lv_data/organized_storage/volumes/volumetmp_03 || true"
  }

  depends_on = [libvirt_pool.volumetmp_03]
}

# Definir configuraciones de nodos y rutas a los archivos Ignition
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

# Crear volúmenes de Ignition para los nodos
resource "libvirt_volume" "ignition_volumes" {
  for_each = local.nodes
  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volumetmp_03.name
  source   = each.value.file
  format   = "raw"

  # Verificar existencia del archivo
  provisioner "local-exec" {
    command = "test -f ${each.value.file} || echo 'Archivo Ignition no encontrado: ${each.value.file}'"
  }
}

# Crear el volumen base de Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base.qcow2"
  pool   = libvirt_pool.volumetmp_03.name
  source = var.coreos_image
  format = "qcow2"
}

# Crear volúmenes individuales de nodos basados en la imagen base
resource "libvirt_volume" "okd_volumes" {
  for_each       = local.nodes
  name           = "${each.key}.qcow2"
  pool           = libvirt_pool.volumetmp_03.name
  size           = each.value.size * 1073741824
  base_volume_id = libvirt_volume.fcos_base.id
}

# Definir dominios VM y conectar los volúmenes Ignition y la red
resource "libvirt_domain" "nodes" {
  for_each = local.nodes
  name     = each.key
  memory   = var.vm_definitions[each.key].memory
  vcpu     = var.vm_definitions[each.key].cpus

  cloudinit = libvirt_volume.ignition_volumes[each.key].id

  network_interface {
    network_name = "kube_network_02"
  }

  disk {
    volume_id = libvirt_volume.okd_volumes[each.key].id
  }
}

# Salida de las IPs de los nodos
output "node_ips" {
  value = { for node in libvirt_domain.nodes : node.name => node.network_interface[0].addresses[0] }
}
