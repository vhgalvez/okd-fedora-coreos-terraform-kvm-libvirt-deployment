 #!/bin/bash

 set -euo pipefail
 exec > /var/log/install-components.log 2>&1
# Crear directorios necesarios
          sudo mkdir -p /opt/bin /etc/kubernetes/pki /opt/cni/bin /etc/kubernetes/pki/etcd

          # Función para verificar si una URL es accesible
          check_url() {
              url=$1
              if ! curl --head --fail --silent "$url" > /dev/null; then
                  echo "Error: La URL $url no es accesible"
                  exit 1
              fi
          }

          # Descargar y configurar Kubelet (v1.31.0)
          KUBELET_URL="https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubelet"
          check_url "$KUBELET_URL"
          sudo curl -L -o /opt/bin/kubelet "$KUBELET_URL"
          sudo chmod +x /opt/bin/kubelet

          # Añadir /opt/bin al PATH si no está ya
          if ! echo "$PATH" | grep -q "/opt/bin"; then
              export PATH=$PATH:/opt/bin
              echo 'export PATH=$PATH:/opt/bin' >> ~/.bashrc
          fi

          # Descargar y configurar OpenShift Client (oc)
          OC_URL="https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
          check_url "$OC_URL"
          sudo curl -L -o /tmp/oc.tar.gz "$OC_URL"
          tar -xzf /tmp/oc.tar.gz -C /tmp
          sudo mv /tmp/oc /opt/bin/oc
          sudo chmod +x /opt/bin/oc

          # Descargar y configurar OKD Installer (v4.14.0)
          OKD_INSTALLER_URL="https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-12-01-225814/openshift-install-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"
          check_url "$OKD_INSTALLER_URL"
          sudo wget -O /tmp/openshift-install.tar.gz "$OKD_INSTALLER_URL"
          tar -xzvf /tmp/openshift-install.tar.gz -C /tmp
          sudo mv /tmp/openshift-install /opt/bin/
          sudo chmod +x /opt/bin/openshift-install

          # Descargar y configurar componentes de Kubernetes (v1.31.0)
          KUBE_COMPONENTS=("kube-proxy" "kube-scheduler" "kube-controller-manager")
          for component in "${KUBE_COMPONENTS[@]}"; do
              URL="https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/$component"
              check_url "$URL"
              sudo curl -L -o /opt/bin/"$component" "$URL"
              sudo chmod +x /opt/bin/"$component"
          done

          # Descargar y configurar etcd (v3.5.7)
          ETCD_URL="https://github.com/etcd-io/etcd/releases/download/v3.5.7/etcd-v3.5.7-linux-amd64.tar.gz"
          check_url "$ETCD_URL"
          sudo curl -L -o /tmp/etcd.tar.gz "$ETCD_URL"
          tar -xzf /tmp/etcd.tar.gz -C /tmp
          sudo mv /tmp/etcd-v3.5.7-linux-amd64/etcd /opt/bin/etcd
          sudo chmod +x /opt/bin/etcd
          sudo rm -rf /tmp/etcd*

          # Descargar e instalar CRI-O (v1.30.5)
          CRIO_URL="https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.5.tar.gz"
          check_url "$CRIO_URL"
          sudo wget -O /tmp/crio.tar.gz "$CRIO_URL"
          sudo tar -xzf /tmp/crio.tar.gz -C /opt/bin/
          sudo chmod +x /opt/bin/crio/crio
          sudo rm -rf /tmp/crio.tar.gz

          # Aplicar configuraciones SELinux si es necesario
          if command -v selinuxenabled &> /dev/null && selinuxenabled; then
              if command -v chcon &> /dev/null; then
                  sudo chcon -u system_u -r object_r -t container_runtime_exec_t /opt/bin/crio
              fi
          fi

          # Recargar daemon de systemd y habilitar crio
          sudo systemctl daemon-reload || { echo "Error al recargar daemon de systemd"; exit 1; }
          sudo systemctl enable --now crio || { echo "Error al habilitar crio"; exit 1; }

          # Descargar certificados kubelet (específicos para cada nodo)
          CERT_BASE_URL="http://10.17.3.14/certificates"
          NODES_CERTS=("kubelet" "ca" "apiserver" "sa" "etcd")
          for cert in "${NODES_CERTS[@]}"; do
              sudo curl -o /etc/kubernetes/pki/"${cert}".crt "$CERT_BASE_URL/${cert}/${cert}.crt"
              sudo curl -o /etc/kubernetes/pki/"${cert}".key "$CERT_BASE_URL/${cert}/${cert}.key"
          done

          # Verificar permisos de claves privadas
          sudo chmod 600 /etc/kubernetes/pki/*.key || { echo "Error al cambiar permisos"; exit 1; }
          sudo chown root:root /etc/kubernetes/pki/*.key || { echo "Error al cambiar propiedad"; exit 1; }

          # Recargar y activar los servicios de Kubernetes
          KUBE_SERVICES=("crio" "kubelet" "kube-proxy" "etcd" "kube-controller-manager" "kube-apiserver" "kube-scheduler")
          for service in "${KUBE_SERVICES[@]}"; do
              sudo systemctl enable "$service" || { echo "Error al habilitar $service"; exit 1; }
              sudo systemctl start "$service" || { echo "Error al iniciar $service"; exit 1; }
          done

          echo "Instalación completada con éxito."