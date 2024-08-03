

:one: Verificar el estado de los servicios

```bash
sudo systemctl status crio
sudo systemctl status etcd
sudo systemctl status kube-apiserver
sudo systemctl status kube-controller-manager
sudo systemctl status kube-scheduler
sudo systemctl status kubelet
```

```bash
sudo systemctl restart crio
sudo systemctl restart etcd
sudo systemctl restart kube-apiserver
sudo systemctl restart kube-controller-manager
sudo systemctl restart kube-scheduler
sudo systemctl restart kubelet
```