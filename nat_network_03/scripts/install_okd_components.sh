#!/bin/bash
set -euo pipefail

# Directorio de instalación
INSTALL_DIR="/opt/bin"

# Crear directorio para binarios
sudo mkdir -p ${INSTALL_DIR}

# Instalar kubelet
curl -L -o ${INSTALL_DIR}/kubelet https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubelet
sudo chmod +x ${INSTALL_DIR}/kubelet

# Instalar oc (OpenShift Client)
curl -L -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
tar -xzf /tmp/oc.tar.gz -C /tmp
sudo mv /tmp/oc ${INSTALL_DIR}/oc
sudo chmod +x ${INSTALL_DIR}/oc
sudo rm -rf /tmp/oc.tar.gz

# Instalar OKD Installer
wget -q https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-03-18-084815/openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
tar -xzvf openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
sudo mv openshift-install ${INSTALL_DIR}/
sudo chmod +x ${INSTALL_DIR}/openshift-install
rm -rf openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz

# Instalar CRI-O
sudo wget -O /tmp/crio.tar.gz https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.3.tar.gz
sudo mkdir -p /tmp/crio
sudo tar -xzf /tmp/crio.tar.gz -C /tmp/crio
sudo mv /tmp/crio/cri-o/bin/* ${INSTALL_DIR}/crio/
sudo chmod +x ${INSTALL_DIR}/crio/*
${INSTALL_DIR}/crio/crio --version

# Instalar conmon
wget https://github.com/containers/conmon/releases/download/v2.1.12/conmon.amd64
sudo mv conmon.amd64 ${INSTALL_DIR}/crio/conmon
sudo chmod +x ${INSTALL_DIR}/crio/conmon