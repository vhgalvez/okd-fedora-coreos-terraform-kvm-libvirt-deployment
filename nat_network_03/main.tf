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

# Create the directory for the pool with correct permissions
resource "null_resource" "create_pool_directory" {
  provisioner "local-exec" {
    command = <<-EOT
      sudo mkdir -p /mnt/lv_data/organized_storage/volumes/volumetmp_03
      sudo chown -R qemu:kvm /mnt/lv_data/organized_storage/volumes/volumetmp_03
      sudo chmod 755 /mnt/lv_data/organized_storage/volumes/volumetmp_03
      echo "Directory created and permissions set" > /tmp/terraform_pool_creation.log
      ls -ld /mnt/lv_data/organized_storage/volumes/volumetmp_03 >> /tmp/terraform_pool_creation.log
    EOT
  }
}

# Wait for the directory to be recognized before proceeding
resource "null_resource" "wait_for_directory" {
  provisioner "local-exec" {
    command = "sleep 10 && ls -ld /mnt/lv_data/organized_storage/volumes/volumetmp_03 >> /tmp/terraform_pool_creation.log"
  }
  depends_on = [null_resource.create_pool_directory]
}

# Define and start the storage pool manually
resource "libvirt_pool" "volume_pool" {
  name = "volumetmp_03"
  type = "dir"
  path = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"

  # Use a manual approach to define, build, start, and autostart the pool
  provisioner "local-exec" {
    command = <<-EOT
      echo "Attempting to create libvirt pool" >> /tmp/terraform_pool_creation.log
      sudo virsh pool-define-as volumetmp_03 dir --target /mnt/lv_data/organized_storage/volumes/volumetmp_03
      sudo virsh pool-build volumetmp_03
      sudo virsh pool-start volumetmp_03
      sudo virsh pool-autostart volumetmp_03
      sudo virsh pool-list --all >> /tmp/terraform_pool_creation.log
    EOT
  }
  depends_on = [null_resource.create_pool_directory, null_resource.wait_for_directory]
}

# Verify the storage pool is properly initialized
resource "null_resource" "verify_pool_initialization" {
  provisioner "local-exec" {
    command = <<-EOT
      sleep 15
      sudo virsh pool-list --all | grep volumetmp_03 && echo "Pool found in virsh pool-list" >> /tmp/terraform_pool_creation.log || (echo "Pool not initialized properly" >> /tmp/terraform_pool_creation.log && exit 1)
      sudo virsh pool-info volumetmp_03 && echo "Successfully retrieved pool info" >> /tmp/terraform_pool_creation.log || (echo "Failed to retrieve pool info" >> /tmp/terraform_pool_creation.log && exit 1)
    EOT
  }
  depends_on = [libvirt_pool.volume_pool]
}

# Network Configuration for VMs
resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}

# Define Fedora CoreOS base image volume
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base"
  pool   = libvirt_pool.volume_pool.name
  source = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
  format = "qcow2"

  depends_on = [libvirt_pool.volume_pool, null_resource.verify_pool_initialization]
}

# Define Ignition configs for bootstrap, master, and worker nodes
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "bootstrap.ign"
  content = file("${path.module}/okd-install/bootstrap.ign")
  depends_on = [libvirt_pool.volume_pool]
}

resource "libvirt_ignition" "master_ignition" {
  name    = "master.ign"
  content = file("${path.module}/okd-install/master.ign")
  depends_on = [libvirt_pool.volume_pool]
}

resource "libvirt_ignition" "worker_ignition" {
  name    = "worker.ign"
  content = file("${path.module}/okd-install/worker.ign")
  depends_on = [libvirt_pool.volume_pool]
}

# Define the bootstrap node
resource "libvirt_domain" "bootstrap" {
  name   = "bootstrap"
  memory = "8192"
  vcpu   = 4

  cloudinit = libvirt_ignition.bootstrap_ignition.id

  network_interface {
    network_name = libvirt_network.okd_network.name
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }

  depends_on = [libvirt_volume.fcos_base, libvirt_ignition.bootstrap_ignition]
}

# Define the master nodes
resource "libvirt_domain" "master" {
  count  = 3
  name   = "master-${count.index + 1}"
  memory = "16384"
  vcpu   = 4

  cloudinit = libvirt_ignition.master_ignition.id

  network_interface {
    network_name = libvirt_network.okd_network.name
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }

  depends_on = [libvirt_volume.fcos_base, libvirt_ignition.master_ignition]
}

# Define the worker nodes
resource "libvirt_domain" "worker" {
  count  = 3
  name   = "worker-${count.index + 1}"
  memory = "8192"
  vcpu   = 4

  cloudinit = libvirt_ignition.worker_ignition.id

  network_interface {
    network_name = libvirt_network.okd_network.name
  }

  disk {
    volume_id = libvirt_volume.fcos_base.id
  }

  depends_on = [libvirt_volume.fcos_base, libvirt_ignition.worker_ignition]
}

# Output the IP addresses of the nodes
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
