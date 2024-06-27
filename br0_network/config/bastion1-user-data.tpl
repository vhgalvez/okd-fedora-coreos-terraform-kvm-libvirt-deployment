variant: flatcar
version: 1.1.0

ignition:
  version: 3.4.0

passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - ${ssh_keys}
    - name: root
      password_hash: $6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/

storage:
  files:
    - path: /etc/hostname
      filesystem: "root"
      mode: 0644
      contents:
        inline: ${host_name}
    - path: /home/core/works
      filesystem: "root"
      mode: 0755
      contents:
        inline: |
          #!/bin/bash
          set -euo pipefail
          echo "My name is ${name} and the hostname is ${host_name}"
    - path: /etc/systemd/network/10-eth0.network
      filesystem: "root"
      mode: 0644
      contents:
        inline: |
          [Match]
          Name=eth0

          [Network]
          Address=${ip}/24
          Gateway=${gateway}
          DNS=${dns1}
          DNS=${dns2}
    - path: /etc/tmpfiles.d/hosts.conf
      filesystem: "root"
      mode: 0644
      contents:
        inline: |
          f /etc/hosts 0644 - - - -
          127.0.0.1   localhost
          ::1         localhost
          ${ip}  ${host_name} ${name}
    - path: /run/systemd/resolve/resolv.conf
      filesystem: "root"
      mode: 0644
      contents:
        inline: |
          nameserver ${dns1}
          nameserver ${dns2}
    - path: /etc/tmpfiles.d/resolv.conf
      filesystem: "root"
      mode: 0644
      contents:
        inline: |
          L /etc/resolv.conf - - - - /run/systemd/resolve/resolv.conf
    - path: /usr/local/bin/set-hosts.sh
      filesystem: "root"
      mode: 0755
      contents: |
        #!/bin/bash
        echo "127.0.0.1   localhost" > /etc/hosts
        echo "::1         localhost" >> /etc/hosts
        echo "${ip}  ${host_name} ${name}" >> /etc/hosts

systemd:
  units:
    - name: apply-network-routes.service
      enabled: true
      contents: |
        [Unit]
        Description=Apply custom network routes
        After=network-online.target
        Wants=network-online.target

        [Service]
        Type=oneshot
        ExecStart=/usr/bin/systemctl restart systemd-networkd.service
        RemainAfterExit=true

        [Install]
        WantedBy=multi-user.target
    - name: set-hosts.service
      enabled: true
      contents: |
        [Unit]
        Description=Set /etc/hosts file
        After=network.target
        Requires=create-set-hosts.service
        After=create-set-hosts.service

        [Service]
        Type=oneshot
        ExecStart=/usr/local/bin/set-hosts.sh
        RemainAfterExit=true

        [Install]
        WantedBy=multi-user.target
