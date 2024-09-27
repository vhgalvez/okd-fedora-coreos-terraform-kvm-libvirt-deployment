base_image = "/mnt/lv_data/organized_storage/images/flatcar_production_qemu_image.img"

coreos_image = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20210626.3.0/x86_64/fedora-coreos-34.20210626.3.0-qemu.x86_64.qcow2.xz"

vm_definitions = {
  bootstrap = { cpus = 4, memory = 8192 }
  master1   = { cpus = 4, memory = 16384 }
  master2   = { cpus = 4, memory = 16384 }
  master3   = { cpus = 4, memory = 16384 }
  worker1   = { cpus = 4, memory = 8192 }
  worker2   = { cpus = 4, memory = 8192 }
  worker3   = { cpus = 4, memory = 8192 }
}

gateway = "10.17.4.1"
dns1    = "10.17.3.11"
dns2    = "8.8.8.8"

ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC9XqGWEd2de3Ud8TgvzFchK2/SYh+WHohA1KEuveXjCbse9aXKmNAZ369vaGFFGrxbSptMeEt41ytEFpU09gAXM6KSsQWGZxfkCJQSWIaIEAdft7QHnTpMeronSgYZIU+5P7/RJcVhHBXfjLHV6giHxFRJ9MF7n6sms38VsuF2s4smI03DWGWP6Ro7siXvd+LBu2gDqosQaZQiz5/FX5YWxvuhq0E/ACas/JE8fjIL9DQPcFrgQkNAv1kHpIWRqSLPwyTMMxGgFxGI8aCTH/Uaxbqa7Qm/aBfdG2lZBE1XU6HRjAToFmqsPJv4LkBxaC1Ag62QPXONNxAA97arICr vhgalvez@gmail.com"
]
