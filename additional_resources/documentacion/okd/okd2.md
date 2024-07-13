### Guía de Instalación de OKD (OpenShift Kubernetes Distribution) Multinodo en KVM (Continuación)

---

### Entradas DNS (Continuación)

Configura las siguientes entradas DNS en FreeIPA:

```bash
ipa dnsrecord-add cefaslocalserver.com api.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com api-int.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master1.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master2.produccion --a-rec=10.17.4.22
ipa dnsrecord-add cefaslocalserver.com master3.produccion --a-rec=10.17.4.23
ipa dnsrecord-add cefaslocalserver.com worker1.produccion --a-rec=10.17.4.24
ipa dnsrecord-add cefaslocalserver.com worker2.produccion --a-rec=10.17.4.25
ipa dnsrecord-add cefaslocalserver.com worker3.produccion --a-rec=10.17.4.26
```

#### Propósitos de las Entradas DNS

- **api.produccion (10.17.4.21):**
  - **Propósito:** Facilita el acceso externo a la API del clúster OKD.
  - **Uso:** Utilizado por desarrolladores, herramientas CI/CD y otros usuarios externos para interactuar con el clúster.

- **api-int.produccion (10.17.4.21):**
  - **Propósito:** Facilita el acceso interno a la API del clúster OKD.
  - **Uso:** Utilizado por componentes internos del clúster para comunicarse entre sí, optimizando la eficiencia y reduciendo la carga en el balanceador de carga.

- **master1.produccion (10.17.4.21):**
  - **Propósito:** Permite el acceso directo al primer nodo maestro.
  - **Uso:** Utilizado para tareas de administración, mantenimiento y monitoreo específico del nodo maestro.

### Función del Balanceador de Carga (Traefik)

El Balanceador de Carga (Traefik) con la IP 10.17.3.12 se utiliza para distribuir el tráfico entrante entre los nodos maestros. Aunque `api.produccion` y `api-int.produccion` apuntan a la misma IP (10.17.4.21), en la práctica, el balanceador de carga dirige este tráfico a los nodos maestros disponibles.

---

### Diagramas de Flujo de Conexión

#### Conexiones Entrantes

- **Traefik:** Las conexiones HTTPS entrantes llegan a Traefik y se distribuyen entre los nodos maestros.
- **DNS:** Las entradas DNS (`api.produccion` y `api-int.produccion`) apuntan a la IP manejada por Traefik, facilitando el balanceo de carga.

#### Comunicación Interna y Externa

- **Interna:** `api-int.produccion` asegura la comunicación entre componentes internos del clúster.
- **Externa:** `api.produccion` gestiona el acceso externo al clúster.

---

Esta guía te ayudará a instalar un clúster OKD multinodo en KVM con los pasos necesarios y las configuraciones específicas para asegurar un despliegue exitoso.

### Contacto

Para cualquier duda o problema, por favor abre un issue en el repositorio o contacta al mantenedor del proyecto.

**Mantenedor del Proyecto:** Victor Galvez

---

### Plantilla Ignition Actualizada

Aquí está la plantilla Ignition actualizada que incluye la configuración para instalar `oc` y establecer `KUBECONFIG` automáticamente:

```yaml
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
    - path: /home/core/install-oc.sh
      filesystem: "root"
      mode: 0755
      contents:
        inline: |
          #!/bin/bash
          curl -L -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
          tar -xzf /tmp/oc.tar.gz -C /tmp
          sudo mv /tmp/oc /usr/local/bin/oc
          sudo rm -rf /tmp/oc.tar.gz
          echo 'export KUBECONFIG=/home/core/okd-install/auth/kubeconfig' >> /home/core/.bashrc
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

        [Service]
        Type=oneshot
        ExecStart=/bin/bash -c 'echo "127.0.0.1   localhost" > /etc/hosts; echo "::1         localhost" >> /etc/hosts; echo "${ip}  ${host_name} ${name}" >> /etc/hosts'
        RemainAfterExit=true

        [Install]
        WantedBy=multi-user.target
    - name: install-oc.service
      enabled: true
      contents: |
        [Unit]
        Description=Install OpenShift CLI (oc)
        After=network-online.target
        Wants=network-online.target

        [Service]
        Type=oneshot
        ExecStart=/home/core/install-oc.sh
        RemainAfterExit=true

        [Install]
        WantedBy=multi-user.target
```

### Verificación

Después de aplicar la configuración, puedes verificar la configuración y la disponibilidad de los nodos:

1. **Accede a los nodos:**
   ```bash
   ssh -i /ruta/a/tu/clave/id_rsa core@10.17.4.21
   ```

2. **Verifica que `oc` esté disponible y configurado:**
   ```bash
   source ~/.bashrc
   oc get nodes
   ```

Siguiendo estos pasos y asegurando la correcta configuración de los nodos, deberías poder instalar y configurar OKD correctamente desde el nodo bootstrap.