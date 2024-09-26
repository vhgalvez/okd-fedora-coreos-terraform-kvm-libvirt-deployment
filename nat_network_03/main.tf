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

# Create or reference the existing NAT network
resource "libvirt_network" "nat_network_02" {
  name = "nat_network_02"
}

# Create the directory for storage pool with correct permissions
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

# Wait for the directory to be recognized before proceeding
resource "null_resource" "wait_for_directory" {
  provisioner "local-exec" {
    command = "sleep 20 && ls -ld /mnt/lv_data/organized_storage/volumes/volumetmp_03 >> /tmp/terraform_pool_creation.log"
  }
  depends_on = [null_resource.create_pool_directory]
}

# Define and start the storage pool
resource "libvirt_pool" "volume_pool" {
  name       = "volumetmp_03"
  type       = "dir"
  path       = "/mnt/lv_data/organized_storage/volumes/volumetmp_03"
  depends_on = [null_resource.create_pool_directory, null_resource.wait_for_directory]
}

# Define base volume for Fedora CoreOS
resource "libvirt_volume" "fcos_base" {
  name   = "fcos_base"
  pool   = libvirt_pool.volume_pool.name
  source = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"
  format = "qcow2"

  depends_on = [libvirt_pool.volume_pool]
}

# Download ignition files from the Helper Node
resource "null_resource" "download_ignition_files" {
  provisioner "local-exec" {
    command = <<-EOT
      set -e
      curl -o /tmp/bootstrap.ign http://10.17.3.14/okd/bootstrap.ign
      curl -o /tmp/master.ign http://10.17.3.14/okd/master.ign
      curl -o /tmp/worker.ign http://10.17.3.14/okd/worker.ign
    EOT
  }
}

# Create volumes for ignition files
resource "libvirt_volume" "bootstrap_ign" {
  name   = "bootstrap-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = "/tmp/bootstrap.ign"
  format = "raw"

  depends_on = [null_resource.download_ignition_files]
}

resource "libvirt_volume" "master_ign" {
  name   = "master-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = "/tmp/master.ign"
  format = "raw"

  depends_on = [null_resource.download_ignition_files]
}

resource "libvirt_volume" "worker_ign" {
  name   = "worker-ignition"
  pool   = libvirt_pool.volume_pool.name
  source = "/tmp/worker.ign"
  format = "raw"

  depends_on = [null_resource.download_ignition_files]
}

# Define the bootstrap node
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

# Define the master nodes
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

# Define the worker nodes
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
