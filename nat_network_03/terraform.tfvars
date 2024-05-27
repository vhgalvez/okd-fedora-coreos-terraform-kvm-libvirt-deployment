
# nat_network_03/terraform.tfvars

base_image = "/var/lib/libvirt/images/flatcar_image/flatcar_image/flatcar_production_qemu_image.img"

vm_definitions = {
  "bootstrap1" = { cpus = 1, memory = 1024, ip = "10.17.4.20" name_dominio = "bootstrap1.cefaslocalserver.com"},
  "master1"    = { cpus = 2, memory = 2048, ip = "10.17.4.21" name_dominio = "master1.cefaslocalserver.com"},
  "master2"    = { cpus = 2, memory = 2048, ip = "10.17.4.22" name_dominio = "master2.cefaslocalserver.com"},
  "master3"    = { cpus = 2, memory = 2048, ip = "10.17.4.23" name_dominio = "master3.cefaslocalserver.com"},
  "worker1"    = { cpus = 2, memory = 2048, ip = "10.17.4.24" name_dominio = "worker1.cefaslocalserver.com"},
  "worker2"    = { cpus = 2, memory = 2048, ip = "10.17.4.25" name_dominio = "worker2.cefaslocalserver.com"},
  "worker3"    = { cpus = 2, memory = 2048, ip = "10.17.4.26" name_dominio = "worker3.cefaslocalserver.com"},
}

ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC9XqGWEd2de3Ud8TgvzFchK2/SYh+WHohA1KEuveXjCbse9aXKmNAZ369vaGFFGrxbSptMeEt41ytEFpU09gAXM6KSsQWGZxfkCJQSWIaIEAdft7QHnTpMeronSgYZIU+5P7/RJcVhHBXfjLHV6giHxFRJ9MF7n6sms38VsuF2s4smI03DWGWP6Ro7siXvd+LBu2gDqosQaZQiz5/FX5YWxvuhq0E/ACas/JE8fjIL9DQPcFrgQkNAv1kHpIWRqSLPwyTMMxGgFxGI8aCTH/Uaxbqa7Qm/aBfdG2lZBE1XU6HRjAToFmqsPJv4LkBxaC1Ag62QPXONNxAA97arICr vhgalvez@gmail.com"
]
gateway        = "10.17.4.1"
dns1           = "8.8.8.8"
dns2           = "10.17.4.11"
