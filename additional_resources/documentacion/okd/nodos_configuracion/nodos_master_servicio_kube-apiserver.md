# Servicio kube-apiserver – Instalación y Configuración Actualizada


## 2. Instalación y Configuración de kube-apiserver

### 2.1 Crear Certificados para kube-apiserver


```bash
sudo systemctl status kube-apiserver
```

**Generar la Clave Privada y Certificado de la CA para kube-apiserver**

1. Generar la clave privada y el certificado de la CA para `kube-apiserver`:

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/ca.key 2048
sudo openssl req -x509 -new -nodes -key /etc/kubernetes/pki/ca.key -subj "/CN=kubernetes-ca" -days 365 -out /etc/kubernetes/pki/ca.crt
```

2. Generar la clave privada para `kube-apiserver`:


```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver.key 2048
```

3. Crear la solicitud de firma de certificado (CSR) para `kube-apiserver`:

```bash
sudo openssl req -new -key /etc/kubernetes/pki/apiserver.key -subj "/CN=kube-apiserver" -out /etc/kubernetes/pki/apiserver.csr
```

4. Crear el archivo de configuración de OpenSSL para `kube-apiserver`:

sudo tee /etc/kubernetes/pki/v3_req.cnf <<EOF
[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.17.4.22
IP.2 = 10.96.0.1
EOF


5. Firmar el CSR de kube-apiserver con la CA:

   
```bash
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/v3_req.cnf
```



### 2.2 Generar el Certificado de Cliente para etcd

1. Generar la clave privada para apiserver-etcd-client:


```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-etcd-client.key 2048
```



2. Crear el CSR para el cliente apiserver-etcd-client:

```bash
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -subj "/CN=apiserver-etcd-client" -out /etc/kubernetes/pki/apiserver-etcd-client.csr
```



3. Firmar el CSR con la CA de etcd:

```bash
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt -days 365
```


### 2.3 Crear el Servicio para kube-apiserver

1. Configurar el archivo de servicio de kube-apiserver:
  
```bash
sudo vim /etc/systemd/system/kube-apiserver.service
```

2. Contenido del archivo kube-apiserver.service:


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

### 2.4 Iniciar y Verificar el Servicio kube-apiserver

1. Recargar systemd y arrancar kube-apiserver:

```bash
sudo systemctl daemon-reload
sudo systemctl start kube-apiserver
sudo systemctl enable kube-apiserver
```

2. Verificar el estado de kube-apiserver:

```bash
sudo systemctl status kube-apiserver
sudo journalctl -u kube-apiserver -f
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
IP.1 = 10.17.4.22
IP.2 = 10.96.0.1
```


```bash
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/v3_req.cnf
```


```bash
sudo systemctl daemon-reload
sudo systemctl restart kube-apiserver
sudo journalctl -u kube-apiserver
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
