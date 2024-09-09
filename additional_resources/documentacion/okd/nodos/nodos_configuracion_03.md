


sudo systemctl daemon-reload


sudo systemctl enable crio
sudo systemctl start crio
sudo systemctl restart crio
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl restart kubelet
sudo systemctl status kubelet
sudo systemctl status crio



sudo systemctl status kube-controller-manager
sudo systemctl status kube-scheduler
sudo systemctl status kube-apiserver
sudo systemctl status kube-proxy
sudo systemctl status kubelet
sudo systemctl status etcd
sudo systemctl status crio



sudo systemctl status crio etcd kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy | grep -i "active (running)"

sudo systemctl restart crio etcd kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy

sudo systemctl status crio etcd kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy



[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
Wants=crio.service
After=crio.service

[Service]
ExecStart=/opt/bin/kubelet --config=/etc/kubernetes/kubelet-config.yaml --kubeconfig=/etc/kubernetes/kubelet.conf --hostname-override=master1.cefaslocalserver.com
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target


sudo virsh start freeipa1
sudo virsh start load_balancer1
sudo virsh start bootstrap
sudo virsh start helper
sudo virsh start master1
sudo virsh start master2

sudo virsh list --all

sudo virsh shutdown  freeipa1
sudo virsh shutdown  load_balancer1
sudo virsh shutdown  bootstrap
sudo virsh shutdown  helper
sudo virsh shutdown  master1
sudo virsh shutdown  master2
sudo virsh shutdown  master2
sudo virsh shutdown  master3
sudo virsh shutdown  worker1
sudo virsh shutdown  worker2
sudo virsh shutdown  worker3



sudo virsh start freeipa1
sudo virsh start load_balancer1
sudo virsh start helper
sudo virsh start master1
sudo virsh start master2




cat /etc/kubernetes/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  x509:
    clientCAFile: "/etc/kubernetes/pki/ca.crt"
authorization:
  mode: Webhook
serverTLSBootstrap: true
tlsCertFile: "/etc/kubernetes/pki/kubelet.crt"
tlsPrivateKeyFile: "/etc/kubernetes/pki/kubelet.key"
cgroupDriver: systemd
runtimeRequestTimeout: "15m"
containerRuntimeEndpoint: "unix:///var/run/crio/crio.sock"



  - path: /home/core/install
      filesystem: root
      mode: 0755
      contents:
        source: "http://10.17.3.14/certificates/install-cri-o/install"



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

          # Descargar y instalar CRI-O (v1.30.5)
          check_url "https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.5.tar.gz"
          sudo wget -O /tmp/crio.tar.gz "https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.5.tar.gz"
          sudo mkdir -p /opt/cni/bin /opt/bin/
          sudo tar -xzf /tmp/crio.tar.gz -C /opt/bin/
          sudo chmod +x /opt/bin/crio/crio
          sudo rm -rf /tmp/crio.tar.gz
          
          # instalar
          # Descargar el archivo 'install' desde el servidor
          check_url http://10.17.3.14/certificates/install-cri-o/install
          sudo curl -o /home/core/install http://10.17.3.14/certificates/install-cri-o/install
          sudo chmod +x /home/core/install
          sudo /home/core/install
          
          # Añadir CRI-O y CNI al PATH
          export PATH=$PATH:/opt/bin/
          export PATH=$PATH:/opt/bin/cri-o/bin/

          # Aplicar configuraciones SELinux si es necesario
          if command -v selinuxenabled &> /dev/null && selinuxenabled; then
              if command -v chcon &> /dev/null; then
                  sudo chcon -u system_u -r object_r -t container_runtime_exec_t /opt/bin/crio
              fi
          fi

          # Recargar daemon de systemd y habilitar crio
          sudo systemctl daemon-reload || { echo "Error al recargar daemon de systemd"; exit 1; }
          sudo systemctl enable --now crio || { echo "Error al habilitar crio"; exit 1; }
          sudo systemctl enable extensions-crio.slice
          sudo systemctl start extensions-crio.slice

          # Instalar kube-proxy
          check_url "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-proxy"
          sudo curl -L -o /opt/bin/kube-proxy "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-proxy"
          sudo chmod +x /opt/bin/kube-proxy

          # Instalar etcd
          check_url "https://github.com/etcd-io/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz"
          curl -L -o /tmp/etcd.tar.gz "https://github.com/etcd-io/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz"
          tar -xzf /tmp/etcd.tar.gz -C /tmp
          sudo mv /tmp/etcd-v3.4.13-linux-amd64/etcd /opt/bin/etcd
          sudo chmod +x /opt/bin/etcd
          sudo rm -rf /tmp/etcd.tar.gz /tmp/etcd-v3.4.13-linux-amd64

          # Instalar kube-apiserver
          check_url "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-apiserver"
          sudo curl -L -o /opt/bin/kube-apiserver "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-apiserver"
          sudo chmod +x /opt/bin/kube-apiserver

          # Instalar kube-controller-manager
          check_url "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-controller-manager"
          sudo curl -L -o /opt/bin/kube-controller-manager "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-controller-manager"
          sudo chmod +x /opt/bin/kube-controller-manager

          # Instalar kube-scheduler
          check_url "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-scheduler"
          sudo curl -L -o /opt/bin/kube-scheduler "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-scheduler"
          sudo chmod +x /opt/bin/kube-scheduler

          # Instalar kubelet
          check_url "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubelet"
          sudo curl -L -o /opt/bin/kubelet "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubelet"
          sudo chmod +x /opt/bin/kubelet

          # Instalar oc (OpenShift Client)
          check_url "https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
          sudo curl -L -o /tmp/oc.tar.gz "https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
          tar -xzf /tmp/oc.tar.gz -C /tmp
          sudo mv /tmp/oc /opt/bin/oc
          sudo chmod +x /opt/bin/oc
          sudo rm -rf /tmp/oc.tar.gz
            # Download and store certificates

          # Descargar certificados kubelet
          sudo curl -o /etc/kubernetes/pki/kubelet.crt http://10.17.3.14/certificates/${node_name}/kubelet/kubelet.crt
          sudo curl -o /etc/kubernetes/pki/kubelet.key http://10.17.3.14/certificates/${node_name}/kubelet/kubelet.key

          # Descargar certificado y clave CA
          sudo curl -o /etc/kubernetes/pki/ca.crt http://10.17.3.14/certificates/shared/ca/ca.crt
          sudo curl -o /etc/kubernetes/pki/ca.key http://10.17.3.14/certificates/shared/ca/ca.key

          # Descargar certificados para el nodo master1
          sudo curl -o /etc/kubernetes/pki/kubelet.crt http://10.17.3.14/certificates/master1/kubelet/kubelet.crt
          sudo curl -o /etc/kubernetes/pki/kubelet.key http://10.17.3.14/certificates/master1/kubelet/kubelet.key

          # Descargar certificados del servidor API
          sudo curl -o /etc/kubernetes/pki/apiserver.crt http://10.17.3.14/certificates/shared/apiserver/apiserver.crt
          sudo curl -o /etc/kubernetes/pki/apiserver.key http://10.17.3.14/certificates/shared/apiserver/apiserver.key

          # Descargar claves públicas y privadas para el Service Account
          sudo curl -o /etc/kubernetes/pki/sa.pub http://10.17.3.14/certificates/shared/sa/sa.pub
          sudo curl -o /etc/kubernetes/pki/sa.key http://10.17.3.14/certificates/shared/sa/sa.key

          # Descargar certificados etcd
          sudo curl -o /etc/kubernetes/pki/etcd/etcd.key http://10.17.3.14/certificates/shared/etcd/etcd.key
          sudo curl -o /etc/kubernetes/pki/etcd/etcd.crt http://10.17.3.14/certificates/shared/etcd/etcd.crt
          sudo curl -o /etc/kubernetes/pki/etcd/ca.crt http://10.17.3.14/certificates/shared/ca/ca.crt

          # Descargar certificados cliente API Server para etcd
          sudo curl -o /etc/kubernetes/pki/apiserver-etcd-client.crt http://10.17.3.14/certificates/shared/apiserver-etcd-client/apiserver-etcd-client.crt
          sudo curl -o /etc/kubernetes/pki/apiserver-etcd-client.key http://10.17.3.14/certificates/shared/apiserver-etcd-client/apiserver-etcd-client.key

          # Descargar certificados cliente API Server para kubelet
          sudo curl -o /etc/kubernetes/pki/apiserver-kubelet-client.crt http://10.17.3.14/certificates/shared/apiserver-kubelet-client/apiserver-kubelet-client.crt
          sudo curl -o /etc/kubernetes/pki/apiserver-kubelet-client.key http://10.17.3.14/certificates/shared/apiserver-kubelet-client/apiserver-kubelet-client.key

          # Verify and set permissions for private keys
          sudo chmod 600 /etc/kubernetes/pki/*.key /etc/kubernetes/pki/etcd/*.key
          sudo chown root:root /etc/kubernetes/pki/*.key /etc/kubernetes/pki/etcd/*.key

          # Reload systemd and activate services
          sudo systemctl daemon-reload
          sudo systemctl enable crio kubelet kube-proxy etcd kube-controller-manager kube-apiserver kube-scheduler
          sudo systemctl start crio kubelet kube-proxy etcd kube-controller-manager kube-apiserver kube-scheduler