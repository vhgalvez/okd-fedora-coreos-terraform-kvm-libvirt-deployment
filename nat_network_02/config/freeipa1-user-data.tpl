#cloud-config
hostname: ${hostname}
manage_etc_hosts: false

growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false

resize_rootfs: true

users:
  - default
  - name: core
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: [adm, wheel]
    lock_passwd: false
    ssh_authorized_keys:
      - ssh-rsa AAAAB3...your-public-key...rest-of-the-key
    passwd: $6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/

  - name: root
    ssh_authorized_keys:
      - ssh-rsa AAAAB3...your-public-key...rest-of-the-key
    passwd: $6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/

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

  - path: /etc/NetworkManager/conf.d/dns.conf
    content: |
      [main]
      dns=none

  - path: /usr/local/bin/set-dns.sh
    content: |
      #!/bin/bash
      echo "search cefaslocalserver.com" > /etc/resolv.conf
      echo "nameserver 10.17.3.11" >> /etc/resolv.conf
      echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    permissions: "0755"


runcmd:
  - systemctl restart NetworkManager
  - /usr/local/bin/set-dns.sh
  - echo "Instance setup completed" >> /var/log/cloud-init-output.log
  - ip route add 10.17.4.0/24 via 10.17.3.1 dev eth0
  - ip route add 192.168.0.0/24 via 10.17.3.1 dev eth0
  - dnf install -y firewalld
  - systemctl enable --now firewalld
  - systemctl restart NetworkManager.service

timezone: ${timezone}
