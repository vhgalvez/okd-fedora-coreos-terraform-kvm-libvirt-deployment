


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



sudo virsh list --all


sudo virsh start freeipa1
sudo virsh start load_balancer1
sudo virsh start helper
sudo virsh start postgresql1


sudo virsh start master1
sudo virsh start master2
sudo virsh start bastion1.cefaslocalserver.com 


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
sudo virsh start bootstrap
sudo virsh start master1
sudo virsh start master2
sudo virsh start master3
sudo virsh start worker1
sudo virsh start worker2
sudo virsh start worker3


sudo virsh start freeipa1
sudo virsh start load_balancer1

sudo virsh start helper



sudo virsh shutdown freeipa1
sudo virsh shutdown load_balancer1
sudo virsh shutdown helper
sudo virsh shutdown bastion1.cefaslocalserver.com
sudo virsh shutdown bootstrap.cefaslocalserver.com
sudo virsh shutdown controlplane_1.cefaslocalserver.com
sudo virsh shutdown controlplane_2.cefaslocalserver.com
sudo virsh shutdown controlplane_3.cefaslocalserver.com
sudo virsh shutdown postgresql1
sudo virsh shutdown worker1.cefaslocalserver.com
sudo virsh shutdown worker2.cefaslocalserver.com
sudo virsh shutdown worker3.cefaslocalserver.com


sudo virsh shutdown freeipa1
sudo virsh shutdown load_balancer1
sudo virsh shutdown helper
sudo virsh shutdown bastion1.cefaslocalserver.com
sudo virsh shutdown bootstrap.cefaslocalserver.com
sudo virsh shutdown controlplane_1.cefaslocalserver.com
sudo virsh shutdown controlplane_2.cefaslocalserver.com
sudo virsh shutdown controlplane_3.cefaslocalserver.com
sudo virsh shutdown postgresql1
sudo virsh shutdown worker1.cefaslocalserver.com
sudo virsh shutdown worker2.cefaslocalserver.com
sudo virsh shutdown worker3.cefaslocalserver.com


sudo virsh shutdown postgresql1
sudo virsh shutdown helper
sudo virsh shutdown bastion1.cefaslocalserver.com






sudo virsh shutdown freeipa1
sudo virsh shutdown load_balancer1
sudo virsh shutdown bastion1.cefaslocalserver.com
sudo virsh shutdown bootstrap.cefaslocalserver.com
sudo virsh shutdown controlplane_1.cefaslocalserver.com
sudo virsh shutdown controlplane_2.cefaslocalserver.com
sudo virsh shutdown controlplane_3.cefaslocalserver.com
sudo virsh shutdown worker1.cefaslocalserver.com
sudo virsh shutdown worker2.cefaslocalserver.com


sudo virsh list --all


sudo virsh shutdown worker3.cefaslocalserver.com


sudo virsh start bastion1.cefaslocalserver.com

sudo virsh start bootstrap.cefaslocalserver.com
sudo virsh start controlplane_1.cefaslocalserver.com
sudo virsh start controlplane_2.cefaslocalserver.com
sudo virsh start controlplane_3.cefaslocalserver.com
sudo virsh start worker1.cefaslocalserver.com
sudo virsh start worker2.cefaslocalserver.com
sudo virsh start worker3.cefaslocalserver.com

sudo virsh start freeipa1
sudo virsh start load_balancer1

sudo virsh start helper



sudo setenforce 0
sudo systemctl restart libvirtd
