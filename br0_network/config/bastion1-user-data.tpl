#cloud-config
hostname: ${hostname}
manage_etc_hosts: true

growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false

resize_rootfs: true

chpasswd:
  list: |
    core:$6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/
    root:$6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/
  expire: false

ssh_pwauth: true
disable_root: false

users:
  - default
  - name: core
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: [adm, wheel]
    lock_passwd: false
    ssh_authorized_keys: ${ssh_keys}

  - name: root
    ssh_authorized_keys: ${ssh_keys}

write_files:
  - encoding: b64
    content: U0VMSU5VWD1kaXNhYmxlZApTRUxJTlVYVFlQRT10YXJnZXRlZCAKIyAK
    owner: root:root
    path: /etc/sysconfig/selinux
    permissions: "0644"

  - path: /etc/systemd/network/10-static-en.network
    content: |
      [Match]
      Name=eth0

      [Network]
      Address=${ip}/24
      Gateway=${gateway}
      DNS=${dns1}
      DNS=${dns2}

  - path: /etc/hosts
    content: |
      127.0.0.1   localhost
      ::1         localhost

      # Añade las entradas para todas las máquinas virtuales y el servidor físico
      10.17.3.11   freeipa1.cefaslocalserver.com   freeipa1
      10.17.3.12   loadbalancer1.cefaslocalserver.com   loadbalancer1
      10.17.3.13   postgresql1.cefaslocalserver.com   postgresql1

      10.17.4.20   bootstrap1.cefaslocalserver.com   bootstrap1
      10.17.4.21   master1.cefaslocalserver.com   master1
      10.17.4.22   master2.cefaslocalserver.com   master2
      10.17.4.23   master3.cefaslocalserver.com   master3
      10.17.4.24   worker1.cefaslocalserver.com   worker1
      10.17.4.25   worker2.cefaslocalserver.com   worker2
      10.17.4.26   worker3.cefaslocalserver.com   worker3

      # Entrada para el servidor bastion1
      192.168.0.20   bastion1.cefaslocalserver.com   bastion1

      # Entrada para el servidor físico
      192.168.0.21   physical1.cefaslocalserver.com   physical1

runcmd:
  - sudo ip route add 10.17.3.0/24 via 192.168.0.21 dev eth0
  - sudo ip route add 10.17.4.0/24 via 192.168.0.21 dev eth0
  - echo "Instance setup completed" >> /var/log/cloud-init-output.log
  - ["dnf", "install", "-y", "firewalld"]
  - ["systemctl", "enable", "--now", "firewalld"]
  - ["systemctl", "restart", "NetworkManager.service"]

timezone: ${timezone}
