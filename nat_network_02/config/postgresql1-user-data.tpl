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

  - encoding: b64
    content: bmFtZXNlcnZlciAxMC4xNy4zLjExCm5hbWVzZXJ2ZXIgOC44LjguOA==
    owner: root:root
    path: /etc/resolv.conf
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

runcmd:
  - echo "Instance setup completed" >> /var/log/cloud-init-output.log
  - ip route add 10.17.4.0/24 via 10.17.3.1 dev eth0
  - ip route add 192.168.0.0/24 via 10.17.3.1 dev eth0
  - ["dnf", "install", "-y", "firewalld"]
  - ["systemctl", "enable", "--now", "firewalld"]
  - ["systemctl", "restart", "NetworkManager.service"]
  - ["bash", "-c", "echo 'dns=none' >> /etc/NetworkManager/NetworkManager.conf"]
  - ["systemctl", "restart", "NetworkManager.service"]
  - ["bash", "-c", "echo 'bmFtZXNlcnZlciAxMC4xNy4zLjExCm5hbWVzZXJ2ZXIgOC44LjguOA==' | base64 -d > /etc/resolv.conf"]


timezone: ${timezone}
