# terraform.tfvars

dns1    = "10.17.3.11"
dns2    = "8.8.8.8"
gateway = "10.17.3.1"

coreos_base_volume = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"

bootstrap_volume_size = 20
master_volume_size    = 30
worker_volume_size    = 30

vm_definitions = {
  bootstrap = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.3.21"
    name_dominio = "bootstrap.cefaslocalserver.com"
    mac          = "52:54:00:00:00:01"
    disk_size    = 51200
  }
  master1 = {
    cpus         = 4
    memory       = 16384
    ip           = "10.17.3.22"
    name_dominio = "master1.cefaslocalserver.com"
    mac          = "52:54:00:00:00:02"
    disk_size    = 51200
  }
  master2 = {
    cpus         = 4
    memory       = 16384
    ip           = "10.17.3.23"
    name_dominio = "master2.cefaslocalserver.com"
    mac          = "52:54:00:00:00:03"
    disk_size    = 51200
  }
  master3 = {
    cpus         = 4
    memory       = 16384
    ip           = "10.17.3.24"
    name_dominio = "master3.cefaslocalserver.com"
    mac          = "52:54:00:00:00:04"
    disk_size    = 51200
  }
  worker1 = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.3.25"
    name_dominio = "worker1.cefaslocalserver.com"
    mac          = "52:54:00:00:00:05"
    disk_size    = 51200
  }
  worker2 = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.3.26"
    name_dominio = "worker2.cefaslocalserver.com"
    mac          = "52:54:00:00:00:06"
    disk_size    = 51200
  }
  worker3 = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.3.27"
    name_dominio = "worker3.cefaslocalserver.com"
    mac          = "52:54:00:00:00:07"
    disk_size    = 51200
  }
}
