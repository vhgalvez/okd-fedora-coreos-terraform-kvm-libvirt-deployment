


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
