# VM Definitions: CPU, Memory, Disk Size, and IP configurations for each node
vm_definitions = {
  bootstrap = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.4.27"
    name_dominio = "bootstrap.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "bootstrap"
  }
  master1 = {
    cpus         = 4
    memory       = 16384
    ip           = "10.17.4.21"
    name_dominio = "master1.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "master1"
  }
  master2 = {
    cpus         = 4
    memory       = 16384
    ip           = "10.17.4.22"
    name_dominio = "master2.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "master2"
  }
  master3 = {
    cpus         = 4
    memory       = 16384
    ip           = "10.17.4.23"
    name_dominio = "master3.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "master3"
  }
  worker1 = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.4.24"
    name_dominio = "worker1.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "worker1"
  }
  worker2 = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.4.25"
    name_dominio = "worker2.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "worker2"
  }
  worker3 = {
    cpus         = 4
    memory       = 8192
    ip           = "10.17.4.26"
    name_dominio = "worker3.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB in MB
    node_name    = "worker3"
  }
}

# DNS Settings
dns1 = "10.17.3.11"
dns2 = "8.8.8.8"

# Base image and CoreOS image download URL
base_image   = "/mnt/lv_data/organized_storage/images/flatcar_production_qemu_image.img"
coreos_image = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"

# Volume sizes (in GB)
bootstrap_volume_size = 20
master_volume_size    = 30
worker_volume_size    = 30

# SSH Public Keys for accessing the nodes
ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC9XqGWEd2de3Ud8TgvzFchK2/SYh+WHohA1KEuveXjCbse9aXKmNAZ369vaGFFGrxbSptMeEt41ytEFpU09gAXM6KSsQWGZxfkCJQSWIaIEAdft7QHnTpMeronSgYZIU+5P7/RJcVhHBXfjLHV6giHxFRJ9MF7n6sms38VsuF2s4smI03DWGWP6Ro7siXvd+LBu2gDqosQaZQiz5/FX5YWxvuhq0E/ACas/JE8fjIL9DQPcFrgQkNAv1kHpIWRqSLPwyTMMxGgFxGI8aCTH/Uaxbqa7Qm/aBfdG2lZBE1XU6HRjAToFmqsPJv4LkBxaC1Ag62QPXONNxAA97arICr vhgalvez@gmail.com"
]
