#!/bin/bash
set -euo pipefail
exec > /var/log/install-components.log 2>&1

# Create necessary directories
sudo mkdir -p /opt/bin /etc/kubernetes/pki /opt/cni/bin /etc/kubernetes/pki/etcd


# Install kube-proxy
curl -L -o /tmp/kube-proxy https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-proxy
sudo mv /tmp/kube-proxy /opt/bin/kube-proxy
sudo chmod +x /opt/bin/kube-proxy

# Install etcd
curl -L -o /tmp/etcd.tar.gz https://github.com/etcd-io/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz
tar -xzf /tmp/etcd.tar.gz -C /tmp
sudo mv /tmp/etcd-v3.4.13-linux-amd64/etcd /opt/bin/etcd
sudo chmod +x /opt/bin/etcd
sudo rm -rf /tmp/etcd.tar.gz /tmp/etcd-v3.4.13-linux-amd64

# Install kube-apiserver
curl -L -o /tmp/kube-apiserver https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-apiserver
sudo mv /tmp/kube-apiserver /opt/bin/kube-apiserver
sudo chmod +x /opt/bin/kube-apiserver

# Install kube-controller-manager
curl -L -o /tmp/kube-controller-manager https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-controller-manager
sudo mv /tmp/kube-controller-manager /opt/bin/kube-controller-manager
sudo chmod +x /opt/bin/kube-controller-manager

# Install kube-scheduler
curl -L -o /tmp/kube-scheduler https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kube-scheduler
sudo mv /tmp/kube-scheduler /opt/bin/kube-scheduler
sudo chmod +x /opt/bin/kube-scheduler

# Install kubelet
curl -L -o /opt/bin/kubelet https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubelet
sudo chmod +x /opt/bin/kubelet

# Install oc (OpenShift Client)
curl -L -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
tar -xzf /tmp/oc.tar.gz -C /tmp
sudo mv /tmp/oc /opt/bin/oc
sudo chmod +x /opt/bin/oc
sudo rm -rf /tmp/oc.tar.gz

# Descargar e instalar CRI-O
sudo curl -L -o /tmp/crio.tar.gz "https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.5.tar.gz"
sudo tar -xzf /tmp/crio.tar.gz -C /opt/bin/
chmod +x /opt/bin/cri-o/crio
rm -rf /tmp/crio.tar.gz

# Añadir CRI-O y CNI al PATH
export PATH=$PATH:/opt/bin/
export PATH=$PATH:/opt/bin/cri-o/bin/

# Descargar archivo de instalación de CRI-O y CNI plugins
curl -L -o /home/core/install "http://10.17.3.14/certificates/install-cri-o/install"
chmod +x /home/core/install

# Descargar e instalar OpenShift Installer (OKD v4.14.0)
sudo curl -L -o /tmp/openshift-install.tar.gz "https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-12-01-225814/openshift-install-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"
sudo tar -xzf /tmp/openshift-install.tar.gz -C /tmp
sudo mv /tmp/openshift-install /opt/bin/
sudo chmod +x /opt/bin/openshift-install

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
sudo systemctl enable --now crio kubelet kube-proxy etcd kube-controller-manager kube-apiserver kube-scheduler
sudo systemctl start crio kubelet kube-proxy etcd kube-controller-manager kube-apiserver kube-scheduler
systemctl enable --now extensions-crio.slice