
# Configuración de Nodos Master

# Servicio crio


```bash
/etc/systemd/system/crio.service
```

```bash
[Unit]
Description=CRI-O container runtime
After=network.target

[Service]
Type=notify
ExecStart=/opt/bin/crio/crio
Environment="PATH=/opt/bin/crio:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Restart=always
RestartSec=5
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
```

# servicio etcd

```bash
sudo vim /etc/systemd/system/etcd.service
```

```bash
[Unit]
Description=etcd
Documentation=https://github.com/coreos/etcd
After=network.target

[Service]
User=etcd
Type=notify
Environment="ETCD_DATA_DIR=/var/lib/etcd"
Environment="ETCD_NAME=etcd0"
Environment="ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.17.4.22:2380"
Environment="ETCD_LISTEN_PEER_URLS=https://10.17.4.21:2380"
Environment="ETCD_LISTEN_CLIENT_URLS=https://10.17.4.21:2379,https://127.0.0.1:2379"
Environment="ETCD_ADVERTISE_CLIENT_URLS=https://10.17.4.21:2379"
Environment="ETCD_INITIAL_CLUSTER=etcd0=https://10.17.4.21:2380"
Environment="ETCD_INITIAL_CLUSTER_STATE=new"
Environment="ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster"
Environment="ETCD_CERT_FILE=/etc/kubernetes/pki/etcd/etcd.crt"
Environment="ETCD_KEY_FILE=/etc/kubernetes/pki/etcd/etcd.key"
Environment="ETCD_TRUSTED_CA_FILE=/etc/kubernetes/pki/etcd/ca.crt"
Environment="ETCD_CLIENT_CERT_AUTH=true"
Environment="ETCD_PEER_CERT_FILE=/etc/kubernetes/pki/etcd/etcd.crt"
Environment="ETCD_PEER_KEY_FILE=/etc/kubernetes/pki/etcd/etcd.key"
Environment="ETCD_PEER_TRUSTED_CA_FILE=/etc/kubernetes/pki/etcd/ca.crt"
Environment="ETCD_PEER_CLIENT_CERT_AUTH=true"
ExecStart=/opt/bin/etcd
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
```

# Certificados

```bash
mkdir -p /etc/kubernetes/pki/etcd
```

```bash
sudo openssl genpkey -algorithm RSA -out ca.key -pkeyopt rsa_keygen_bits:2048
sudo openssl req -x509 -new -nodes -key ca.key -subj "/CN=etcd-ca" -days 3650 -out ca.crt
sudo openssl genpkey -algorithm RSA -out etcd.key -pkeyopt rsa_keygen_bits:2048
sudo openssl req -new -key etcd.key -subj "/CN=etcd-server" -out etcd.csr
```

```bash
sudo vim /etc/kubernetes/pki/etcd/etcd-openssl.cnf
```

```bash
cat <<EOF > /etc/kubernetes/pki/etcd/etcd-openssl.cnf
[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = etcd
DNS.2 = etcd.local
IP.1 = 127.0.0.1
IP.2 = 10.17.4.22
EOF
```

```bash
sudo openssl x509 -req -in etcd.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcd.crt -days 365 -extensions v3_req -extfile etcd-openssl.cnf
```

```bash
sudo systemctl daemon-reload
sudo systemctl restart etcd
```

# Servicio kube-apiserver

```bash
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - name: kube-apiserver
    image: k8s.gcr.io/kube-apiserver:v1.20.0
    command:
    - kube-apiserver
    - --advertise-address=10.17.4.21
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://10.17.4.21:2379
    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
    - --secure-port=6443
    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
    - --service-cluster-ip-range=10.96.0.0/12
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
    - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
    volumeMounts:
    - mountPath: /etc/kubernetes/pki
      name: pki
      readOnly: true
  volumes:
  - name: pki
    hostPath:
      path: /etc/kubernetes/pki
```