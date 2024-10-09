# DNS and Gateway settings
dns1    = "10.17.3.11"
dns2    = "8.8.8.8"
gateway = "10.17.3.1"

# Path to CoreOS image
coreos_image = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"

# Volume sizes for bootstrap, control plane (masters), and worker nodes
bootstrap_volume_size = 20
controlplane_1_volume_size = 30
controlplane_2_volume_size = 30
controlplane_3_volume_size = 30
worker_1_volume_size = 30
worker_2_volume_size = 30
worker_3_volume_size = 30

# Define the bootstrap node
bootstrap = {
  name    = "bootstrap.cefaslocalserver.com"
  memory  = 8192
  vcpu    = 4
  address = "10.17.3.21"
  mac     = "52:54:00:00:00:01"
}

# Define control plane nodes
controlplane_1 = {
  name    = "controlplane1.cefaslocalserver.com"
  memory  = 16384
  vcpu    = 4
  address = "10.17.3.22"
  mac     = "52:54:00:00:00:02"
}

controlplane_2 = {
  name    = "controlplane2.cefaslocalserver.com"
  memory  = 16384
  vcpu    = 4
  address = "10.17.3.23"
  mac     = "52:54:00:00:00:03"
}

controlplane_3 = {
  name    = "controlplane3.cefaslocalserver.com"
  memory  = 16384
  vcpu    = 4
  address = "10.17.3.24"
  mac     = "52:54:00:00:00:04"
}

# Define worker nodes
worker_1 = {
  name    = "worker1.cefaslocalserver.com"
  memory  = 8192
  vcpu    = 4
  address = "10.17.3.25"
  mac     = "52:54:00:00:00:05"
}

worker_2 = {
  name    = "worker2.cefaslocalserver.com"
  memory  = 8192
  vcpu    = 4
  address = "10.17.3.26"
  mac     = "52:54:00:00:00:06"
}

worker_3 = {
  name    = "worker3.cefaslocalserver.com"
  memory  = 8192
  vcpu    = 4
  address = "10.17.3.27"
  mac     = "52:54:00:00:00:07"
}
