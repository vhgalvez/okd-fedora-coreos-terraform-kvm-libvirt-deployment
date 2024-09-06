
# Configuración de Nodos Master

# Servicio crio
  
```bash
sudo systemctl status crio
```


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


```bash
sudo systemctl daemon-reload
sudo systemctl restart etcd
```

# Servicio etcd

```bash
sudo systemctl status etcd
```

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


## Certificados

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
sudo systemctl status kube-apiserver
```


```bash
[Unit]
Description=Kubernetes API Server
Documentation=https://kubernetes.io/docs/concepts/overview/components/
After=network.target

[Service]
ExecStart=/opt/bin/kube-apiserver \
  --advertise-address=10.17.4.21 \
  --allow-privileged=true \
  --authorization-mode=Node,RBAC \
  --client-ca-file=/etc/kubernetes/pki/ca.crt \
  --enable-admission-plugins=NodeRestriction \
  --etcd-servers=https://127.0.0.1:2379 \
  --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt \
  --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt \
  --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key \
  --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt \
  --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key \
  --runtime-config=api/all=true \
  --service-account-key-file=/etc/kubernetes/pki/sa.pub \
  --service-account-signing-key-file=/etc/kubernetes/pki/sa.key \
  --service-account-issuer=https://kubernetes.default.svc.cluster.local \
  --service-cluster-ip-range=10.96.0.0/12 \
  --tls-cert-file=/etc/kubernetes/pki/apiserver.crt \
  --tls-private-key-file=/etc/kubernetes/pki/apiserver.key \
  --v=2
Restart=on-failure

[Install]
WantedBy=multi-user.target
```



## 1. Crear el Certificado de Autoridad (CA)

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/ca.key 2048

sudo openssl req -x509 -new -nodes -key /etc/kubernetes/pki/ca.key -subj "/CN=kubernetes-ca" -days 365 -out /etc/kubernetes/pki/ca.crt
```


## 2. Generar el certificado y clave privada del kube-apiserver

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver.key 2048

sudo openssl req -new -key /etc/kubernetes/pki/apiserver.key -out /etc/kubernetes/pki/apiserver.csr -subj "/CN=kube-apiserver"
```

```bash
sudo vim /etc/kubernetes/pki/v3_req.cnf
```

```bash
[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.17.4.21
IP.2 = 10.96.0.1
```


```bash
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/v3_req.cnf
```




## 3.  Generar el certificado de cliente para etcd


```bash
sudo vim /etc/systemd/system/kube-apiserver.service
```


```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-etcd-client.key 2048

sudo openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -out /etc/kubernetes/pki/apiserver-etcd-client.csr -subj "/CN=etcd-client"

sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt -days 365
```


## 4. Crear el certificado para la conexión entre kube-apiserver y kubelet


```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-kubelet-client.key 2048

sudo openssl req -new -key /etc/kubernetes/pki/apiserver-kubelet-client.key -out /etc/kubernetes/pki/apiserver-kubelet-client.csr -subj "/CN=kube-apiserver-kubelet-client"

sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-kubelet-client.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-kubelet-client.crt -days 365
```

##  5. Generar claves y certificados para las cuentas de servicio

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/sa.key 2048
sudo openssl rsa -in /etc/kubernetes/pki/sa.key -pubout -out /etc/kubernetes/pki/sa.pub
```

```bash
sudo mkdir -p /etc/kubernetes/manifests/
```



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

```bash
sudo systemctl daemon-reload
sudo systemctl restart etcd
```



# Servicio kube-proxy


```bash
sudo systemctl status kube-proxy
```

```bash
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
clientConnection:
  kubeconfig: "/etc/kubernetes/kube-proxy.kubeconfig"
mode: "iptables"
clusterCIDR: "10.244.0.0/16"
```
