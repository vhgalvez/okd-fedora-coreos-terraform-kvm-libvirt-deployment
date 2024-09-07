# Instalación del Servicio etcd

-----------------------------------------

## 1. Crear el servicio etcd

Primero, definimos el archivo de servicio para `etcd`:

Archivo: `/etc/systemd/system/etcd.service`

```bash
[Unit]
Description=etcd
Documentation=https://github.com/coreos/etcd
After=network.target

[Service]
User=etcd
Type=notify
# Directorio de datos para etcd
Environment="ETCD_DATA_DIR=/var/lib/etcd"
# Nombre del nodo etcd
Environment="ETCD_NAME=etcd0"
# URL de publicidad inicial entre pares
Environment="ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.17.4.22:2380"
# Dirección donde escucha el nodo etcd
Environment="ETCD_LISTEN_PEER_URLS=https://10.17.4.21:2380"
# URLs donde el cliente puede conectar al servicio etcd
Environment="ETCD_LISTEN_CLIENT_URLS=https://10.17.4.21:2379,https://127.0.0.1:2379"
# URL que se anuncia a otros nodos para los clientes
Environment="ETCD_ADVERTISE_CLIENT_URLS=https://10.17.4.21:2379"
# Definir el estado inicial del clúster
Environment="ETCD_INITIAL_CLUSTER=etcd0=https://10.17.4.21:2380"
Environment="ETCD_INITIAL_CLUSTER_STATE=new"
Environment="ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster"
# Certificados y claves TLS para la autenticación entre nodos y clientes
Environment="ETCD_CERT_FILE=/etc/kubernetes/pki/etcd/etcd.crt"
Environment="ETCD_KEY_FILE=/etc/kubernetes/pki/etcd/etcd.key"
Environment="ETCD_TRUSTED_CA_FILE=/etc/kubernetes/pki/etcd/ca.crt"
Environment="ETCD_CLIENT_CERT_AUTH=true"
# Certificados para la comunicación entre pares
Environment="ETCD_PEER_CERT_FILE=/etc/kubernetes/pki/etcd/etcd.crt"
Environment="ETCD_PEER_KEY_FILE=/etc/kubernetes/pki/etcd/etcd.key"
Environment="ETCD_PEER_TRUSTED_CA_FILE=/etc/kubernetes/pki/etcd/ca.crt"
Environment="ETCD_PEER_CLIENT_CERT_AUTH=true"
# Comando de ejecución de etcd
ExecStart=/opt/bin/etcd
Restart=always
RestartSec=10s
# Limite de archivos abiertos
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
```


## 2. Crear el servicio etcd

Sigue estos pasos para generar los certificados y claves necesarios para etcd:

**Crear el directorio de certificados:**

```bash
mkdir -p /etc/kubernetes/pki/etcd
cd /etc/kubernetes/pki/etcd
```

**Generar la clave y certificado de la CA:**

```bash
sudo openssl genpkey -algorithm RSA -out ca.key -pkeyopt rsa_keygen_bits:2048
sudo openssl req -x509 -new -nodes -key ca.key -subj "/CN=etcd-ca" -days 3650 -out ca.crt
```


**Generar la clave privada y la solicitud de firma (CSR) para etcd:**

```bash
    sudo openssl genpkey -algorithm RSA -out etcd.key -pkeyopt rsa_keygen_bits:2048
sudo openssl req -new -key etcd.key -subj "/CN=etcd-server" -out etcd.csr
```


**Crear archivo de configuración para OpenSSL:**

```bash
sudo tee /etc/kubernetes/pki/etcd/etcd-openssl.cnf <<EOF
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

**Firmar el CSR con la CA:**

```bash
sudo openssl x509 -req -in etcd.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcd.crt -days 365 -extensions v3_req -extfile etcd-openssl.cnf
```

**Cambiar permisos:**

```bash
sudo chown etcd:etcd *.*
sudo chmod 600 *.key
sudo chmod 644 *.crt
```


## 3. Iniciar y verificar el servicio etcd

Recargar el daemon de systemd y reiniciar el servicio etcd:

```bash
sudo systemctl daemon-reload
sudo systemctl start etcd
sudo systemctl enable etcd
sudo systemctl status etcd
```

# Configuración del servicio kube-apiserver

-----------------------------------------------

Este archivo define el servicio kube-apiserver y cómo se comunica con etcd usando TLS.

Archivo: `/etc/systemd/system/kube-apiserver.service`

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

## 5. Certificados para kube-apiserver

Eliminar certificados anteriores:
    
```bash
sudo rm /etc/kubernetes/pki/apiserver.key /etc/kubernetes/pki/apiserver.crt /etc/kubernetes/pki/apiserver.csr
```

**Generar nueva clave privada:**

```bash
sudo openssl genpkey -algorithm RSA -out /etc/kubernetes/pki/apiserver.key -pkeyopt rsa_keygen_bits:2048
```

**Crear la solicitud de firma de certificado (CSR):**

```bash
sudo openssl req -new -key /etc/kubernetes/pki/apiserver.key -out /etc/kubernetes/pki/apiserver.csr -subj "/CN=kube-apiserver"
```

**Crear archivo de configuración de OpenSSL:**
    
```bash
sudo vim /etc/kubernetes/pki/v3_req.cnf
```

**Contenido del archivo de configuración:**


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

**Firmar el CSR para generar el certificado:**

```bash
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/v3_req.cnf
```

## 6. Certificado de cliente para etcd

**Eliminar los certificados y claves anteriores:**
    
```bash
sudo rm /etc/kubernetes/pki/apiserver-etcd-client.key /etc/kubernetes/pki/apiserver-etcd-client.crt /etc/kubernetes/pki/apiserver-etcd-client.csr
```

**Generar nueva clave privada para apiserver-etcd-client:**

```bash
sudo openssl genpkey -algorithm RSA -out /etc/kubernetes/pki/apiserver-etcd-client.key -pkeyopt rsa_keygen_bits:2048
```

**Crear la CSR para el cliente apiserver-etcd-client:**

```bash
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -subj "/CN=apiserver-etcd-client" -out /etc/kubernetes/pki/apiserver-etcd-client.csr
```

**Firmar el CSR con la CA de etcd:**

```bash
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt -days 365
```

**Verificar los permisos:**

```bash
    sudo chmod 600 /etc/kubernetes/pki/apiserver-etcd-client.key
sudo chmod 644 /etc/kubernetes/pki/apiserver-etcd-client.crt
```

## 7. Reiniciar servicios

**Recarga y reinicia ambos servicios:**

```bash
    sudo systemctl daemon-reload
sudo systemctl restart etcd
sudo systemctl restart kube-apiserver
```


## 8. Verificar los logs

Verifica que no haya errores de certificados en los logs:

```bash
sudo journalctl -u etcd -f
sudo journalctl -u kube-apiserver -f
```