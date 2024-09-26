terraform {
  required_version = ">= 1.9.5"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

provider "local" {}

# Referenciar la red NAT existente
resource "libvirt_network" "nat_network_02" {
  name = "nat_network_02"
}

# Crear el directorio para el almacenamiento con los permisos correctos
resource "null_resource" "create_pool_directory" {
  provisioner "local-exec" {
    command = <<-EOT
      sudo mkdir -p /mnt/lv_data/organized_storage/volumes/volumetmp_03 &&
      sudo chown -R qemu:kvm /mnt/lv_data/organized_storage/volumes/volumetmp_03 &&
      sudo chmod 755 /mnt/lv_data/organized_storage/volumes/volumetmp_03
      echo "Directory created and permissions set" > /tmp/terraform_pool_creation.log
      ls -ld /mnt/lv_data/organized_storage/volumes/volumetmp_03 >> /tmp/terraform_pool_creation.log
    EOT
  }
}

# Esperar a que el directorio sea reconocido antes de continuar
resource "null_resource" "wait_for_directory" {
  provisioner "local-exec" {
    command = "sleep 20 && ls -ld /mnt/lv_data/organized_storage/volumes/volumetmp_03 >> /tmp/terraform_pool_creation.log"
  }
  depends_on = [null_resource.create_pool_directory]
}

# Definir y arrancar el almacenamiento
resource "libvirt_pool" "volume_pool" {
  name       = "volumetmp_03"
  type       = "dir"
  path       = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
  depends_on = [null_resource.create_pool_directory, null_resource.wait_for_directory]
}

# Definir volumen base para Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base"
  pool   = libvirt_pool.volume_pool.name
  source = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
  format = "qcow2"

  depends_on = [libvirt_pool.volume_pool]
}

# Descargar archivos Ignition directamente desde el servidor web
data "http" "bootstrap_ignition" {
  url = "http://10.17.3.14/okd/bootstrap.ign"
}

data "http" "master_ignition" {
  url = "http://10.17.3.14/okd/master.ign"
}

data "http" "worker_ignition" {
  url = "http://10.17.3.14/okd/worker.ign"
}

# Crear volúmenes Ignition a partir de los datos descargados
resource "libvirt_volume" "bootstrap_ign" {
  name    = "bootstrap-ignition"
  pool    = libvirt_pool.volume_pool.name
  content = base64decode(data.http.bootstrap_ignition.body)
  format  = "raw"
}

resource "libvirt_volume" "master_ign" {
  name    = "master-ignition"
  pool    = libvirt_pool.volume_pool.name
  content = base64decode(data.http.master_ignition.body)
  format  = "raw"
}

resource "libvirt_volume" "worker_ign" {
  name    = "worker-ignition"
  pool    = libvirt_pool.volume_pool.name
  content = base64decode(data.http.worker_ignition.body)
  format  = "raw"
}

# Definir el nodo bootstrap
resource "libvirt_domain" "bootstrap" {
  name   = "bootstrap"
  memory = "8192"
  vcpu   = 4

  cloudinit = libvirt_volume.bootstrap_ign.id

  network_interface {
    network_name = libvirt_network.nat_network_02.name
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }

  depends_on = [libvirt_volume.fcos_base, libvirt_volume.bootstrap_ign]
}

# Definir los nodos master
resource "libvirt_domain" "master" {
  count  = 3
  name   = "master-${count.index + 1}"
  memory = "16384"
  vcpu   = 4

  cloudinit = libvirt_volume.master_ign.id

  network_interface {
    network_name = libvirt_network.nat_network_02.name
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }

  depends_on = [libvirt_volume.fcos_base, libvirt_volume.master_ign]
}

# Definir los nodos worker
resource "libvirt_domain" "worker" {
  count  = 3
  name   = "worker-${count.index + 1}"
  memory = "8192"
  vcpu   = 4

  cloudinit = libvirt_volume.worker_ign.id

  network_interface {
    network_name = libvirt_network.nat_network_02.name
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }

  depends_on = [libvirt_volume.fcos_base, libvirt_volume.worker_ign]
}

# Output de las direcciones IP de los nodos
output "ip_addresses" {
  value = {
    bootstrap = libvirt_domain.bootstrap.network_interface.0.addresses[0]
    master1   = libvirt_domain.master[0].network_interface.0.addresses[0]
    master2   = libvirt_domain.master[1].network_interface.0.addresses[0]
    master3   = libvirt_domain.master[2].network_interface.0.addresses[0]
    worker1   = libvirt_domain.worker[0].network_interface.0.addresses[0]
    worker2   = libvirt_domain.worker[1].network_interface.0.addresses[0]
    worker3   = libvirt_domain.worker[2].network_interface.0.addresses[0]
  }
}
