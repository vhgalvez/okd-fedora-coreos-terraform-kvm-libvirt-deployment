# Instalación del Servicio etcd

-----------------------------------------

## 1. Crear el servicio etcd

Primero, definimos el archivo de servicio para `etcd`:

Archivo: `cat /etc/systemd/system/etcd.service`

```bash
sudo vim /etc/systemd/system/etcd.service
```

```bash
sudo tee /etc/systemd/system/etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos/etcd
After=network.target

[Service]
User=etcd
Type=notify
Environment="ETCD_DATA_DIR=/var/lib/etcd"
Environment="ETCD_NAME=etcd0"
Environment="ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.17.4.23:2380"
Environment="ETCD_LISTEN_PEER_URLS=https://10.17.4.23:2380"
Environment="ETCD_LISTEN_CLIENT_URLS=https://10.17.4.23:2379,https://127.0.0.1:2379"
Environment="ETCD_ADVERTISE_CLIENT_URLS=https://10.17.4.23:2379"
Environment="ETCD_INITIAL_CLUSTER=etcd0=https://10.17.4.23:2380"
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
EOF
```


## 2. Crear el servicio etcd

Sigue estos pasos para generar los certificados y claves necesarios para etcd:

**Crear el directorio de certificados:**

```bash
sudo mkdir -p /etc/kubernetes/pki/etcd
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
IP.2 = 10.17.4.23
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


```bash
ls -ld /var/lib/etcd
sudo chown -R etcd:etcd /var/lib/etcd
```


## 3. Iniciar y verificar el servicio etcd

Recargar el daemon de systemd y reiniciar el servicio etcd:

```bash
sudo systemctl daemon-reload
sudo systemctl start etcd
sudo systemctl restart etcd
sudo systemctl start etcd
sudo systemctl enable etcd
sudo systemctl status etcd
```