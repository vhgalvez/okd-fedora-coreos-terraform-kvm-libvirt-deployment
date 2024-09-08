#!/bin/bash

# Kubelet (v1.31.0)
curl -L -o /opt/bin/kubelet https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubelet
sudo chmod +x /opt/bin/kubelet

export PATH=$PATH:/opt/bin
echo "export PATH=\$PATH:/opt/bin" >> ~/.bashrc

# CRI-O (v1.31.3) - Corrected URL
wget -O /tmp/crio.tar.gz https://github.com/cri-o/cri-o/releases/download/v1.31.3/crio.amd64.v1.31.3.tar.gz
sudo mkdir -p /opt/bin/crio
sudo tar -xzf /tmp/crio.tar.gz -C /opt/bin/crio/
sudo chmod +x /opt/bin/crio/*

export PATH=$PATH:/opt/bin/crio
echo "export PATH=\$PATH:/opt/bin/crio" >> ~/.bashrc


# OpenShift Client (oc)
curl -L -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
tar -xzf /tmp/oc.tar.gz -C /tmp
sudo mv /tmp/oc /opt/bin/oc
sudo chmod +x /opt/bin/oc
export PATH=$PATH:/opt/bin
echo "export PATH=\$PATH:/opt/bin" >> ~/.bashrc


# OKD Installer (v4.14.0)
wget https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-10-28/openshift-install-linux-4.14.0-0.okd-2023-10-28.tar.gz
tar -xzvf openshift-install-linux-4.14.0-0.okd-2023-10-28.tar.gz
sudo mv openshift-install /opt/bin/
sudo chmod +x /opt/bin/openshift-install

export PATH=$PATH:/opt/bin
echo "export PATH=\$PATH:/opt/bin" >> ~/.bashrc

# Kube-Proxy, Kube-Apiserver, Kube-Scheduler, y Kube-Controller-Manager (v1.31.0)

# Instalar Kube-Proxy:
curl -L -o /tmp/kube-proxy https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kube-proxy
sudo mv /tmp/kube-proxy /opt/bin/kube-proxy
sudo chmod +x /opt/bin/kube-proxy


# Instalar Kube-Scheduler:
curl -L -o /tmp/kube-scheduler https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kube-scheduler
sudo mv /tmp/kube-scheduler /opt/bin/kube-scheduler
sudo chmod +x /opt/bin/kube-scheduler


# Instalar Kube-Controller-Manager:
curl -L -o /tmp/kube-controller-manager https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kube-controller-manager
sudo mv /tmp/kube-controller-manager /opt/bin/kube-controller-manager
sudo chmod +x /opt/bin/kube-controller-manager


# Etcd (v3.5.7)
curl -L -o /tmp/etcd.tar.gz https://github.com/etcd-io/etcd/releases/download/v3.5.7/etcd-v3.5.7-linux-amd64.tar.gz
tar -xzf /tmp/etcd.tar.gz -C /tmp
sudo mv /tmp/etcd-v3.5.7-linux-amd64/etcd /opt/bin/etcd
sudo chmod +x /opt/bin/etcd
sudo rm -rf /tmp/etcd.tar.gz /tmp/etcd-v3.5.7-linux-amd64

export PATH=$PATH:/opt/bin
echo "export PATH=\$PATH:/opt/bin" >> ~/.bashrc