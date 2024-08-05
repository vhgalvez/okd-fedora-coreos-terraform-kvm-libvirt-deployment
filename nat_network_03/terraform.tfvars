# terraform.tfvars
base_image = "/var/lib/libvirt/images/flatcar_production_qemu_image.img"

vm_definitions = {
  "master1" = {
    name_dominio = "master1.produccion"
    ip           = "10.17.4.21"
    cpus         = 4
    memory       = 8192
    disk_size    = 50
  },
  "master2" = {
    name_dominio = "master2.produccion"
    ip           = "10.17.4.22"
    cpus         = 4
    memory       = 8192
    disk_size    = 50
  },
  "master3" = {
    name_dominio = "master3.produccion"
    ip           = "10.17.4.23"
    cpus         = 4
    memory       = 8192
    disk_size    = 50
  },
  "worker1" = {
    name_dominio = "worker1.produccion"
    ip           = "10.17.4.24"
    cpus         = 2
    memory       = 4096
    disk_size    = 50
  },
  "worker2" = {
    name_dominio = "worker2.produccion"
    ip           = "10.17.4.25"
    cpus         = 2
    memory       = 4096
    disk_size    = 50
  },
  "worker3" = {
    name_dominio = "worker3.produccion"
    ip           = "10.17.4.26"
    cpus         = 2
    memory       = 4096
    disk_size    = 50
  }
}
