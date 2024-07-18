base_image = "/var/lib/libvirt/images/flatcar-linux/flatcar_production_qemu_image.img"

vm_definitions = {
  "master1" = {
    cpus         = 2
    memory       = 4096
    ip           = "10.17.4.21"
    name_dominio = "master1.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB en MB
  }
  "master2" = {
    cpus         = 2
    memory       = 4096
    ip           = "10.17.4.22"
    name_dominio = "master2.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB en MB
  }
  "master3" = {
    cpus         = 2
    memory       = 4096
    ip           = "10.17.4.23"
    name_dominio = "master3.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB en MB
  }
  "worker1" = {
    cpus         = 2
    memory       = 3584
    ip           = "10.17.4.24"
    name_dominio = "worker1.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB en MB
  }
  "worker2" = {
    cpus         = 2
    memory       = 3584
    ip           = "10.17.4.25"
    name_dominio = "worker2.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB en MB
  }
  "worker3" = {
    cpus         = 2
    memory       = 3584
    ip           = "10.17.4.26"
    name_dominio = "worker3.cefaslocalserver.com"
    disk_size    = 51200  # 50 GB en MB
  }
}

ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC9XqGWEd2de3Ud8TgvzFchK2/SYh+WHohA1KEuveXjCbse9aXKmNAZ369vaGFFGrxbSptMeEt41ytEFpU09gAXM6KSsQWGZxfkCJQSWIaIEAdft7QHnTpMeronSgYZIU+5P7/RJcVhHBXfjLHV6giHxFRJ9MF7n6sms38VsuF2s4smI03DWGWP6Ro7siXvd+LBu2gDqosQaZQiz5/FX5YWxvuhq0E/ACas/JE8fjIL9DQPcFrgQkNAv1kHpIWRqSLPwyTMMxGgFxGI8aCTH/Uaxbqa7Qm/aBfdG2lZBE1XU6HRjAToFmqsPJv4LkBxaC1Ag62QPXONNxAA97arICr vhgalvez@gmail.com"
]

gateway = "10.17.4.1"
dns1    = "10.17.3.11"
dns2    = "8.8.8.8"

KUBELET_VERSION = "v1.21.0"
kube_apiserver_version = "v1.21.0"
etcd_version = "v3.4.13"


