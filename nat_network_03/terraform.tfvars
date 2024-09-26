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
