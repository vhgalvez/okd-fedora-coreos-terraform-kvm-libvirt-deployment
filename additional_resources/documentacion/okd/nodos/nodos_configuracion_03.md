


sudo systemctl daemon-reload


sudo systemctl enable crio
sudo systemctl start crio
sudo systemctl restart crio
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl restart kubelet
sudo systemctl status kubelet
sudo systemctl status crio


sudo systemctl status kube-apiserver
sudo systemctl status kube-scheduler
sudo systemctl status kube-controller-manager
sudo systemctl status etcd
sudo systemctl status kubelet
sudo systemctl status kube-proxy
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

