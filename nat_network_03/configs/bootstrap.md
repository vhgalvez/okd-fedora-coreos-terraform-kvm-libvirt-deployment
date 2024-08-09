
# Bootstrap configuration
```bash
sudo tee /etc/kubernetes/kubelet-config.yaml > /dev/null <<EOF
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
address: 0.0.0.0
staticPodPath: /etc/kubernetes/manifests
clusterDomain: cluster.local
clusterDNS:
  - 10.96.0.10
runtimeRequestTimeout: "15m"
cgroupDriver: systemd
failSwapOn: false
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/etc/kubernetes/pki/ca.crt"
authorization:
  mode: Webhook
readOnlyPort: 0
enforceNodeAllocatable: ["pods"]
EOF
```
### kubelet.conf file

```bash
sudo tee /etc/kubernetes/kubelet.conf > /dev/null <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://127.0.0.1:6443
  name: local
contexts:
- context:
    cluster: local
    user: kubelet
  name: local
current-context: local
users:
- name: kubelet
  user:
    client-certificate: /etc/kubernetes/pki/kubelet.crt
    client-key: /etc/kubernetes/pki/kubelet.key
EOF
```


```bash
sudo tee /etc/kubernetes/kubelet.conf > /dev/null <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://10.17.4.21:6443
  name: local
contexts:
- context:
    cluster: local
    user: kubelet
  name: local
current-context: local
users:
- name: kubelet
  user:
    client-certificate: /etc/kubernetes/pki/kubelet.crt
    client-key: /etc/kubernetes/pki/kubelet.key
EOF
```
