# Instalación del Servicio etcd

## 1. Crear el servicio etcd

Primero, definimos el archivo de servicio para `etcd`:

```bash
sudo vim /etc/systemd/system/etcd.service
```

Contenido del archivo `etcd.service`:

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

2. Generación de los certificados para etcd

```bash
mkdir -p /etc/kubernetes/pki/etcd

cd /etc/kubernetes/pki/etcd
```

2.1. Generar la clave privada y el certificado de la Autoridad Certificadora (CA)



```bash
sudo openssl genpkey -algorithm RSA -out ca.key -pkeyopt rsa_keygen_bits:2048

sudo openssl req -x509 -new -nodes -key ca.key -subj "/CN=etcd-ca" -days 3650 -out ca.crt

```


2.2. Generar la clave privada del servidor etcd


```bash
sudo openssl genpkey -algorithm RSA -out etcd.key -pkeyopt rsa_keygen_bits:2048
```




```bash
sudo vim /etc/kubernetes/pki/etcd/etcd-openssl.cnf

[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = etcd
DNS.2 = etcd.local
IP.1 = 127.0.0.1
IP.2 = 10.17.4.22
```

. Comando para generar crear el archivo de configuración de openssl

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
sudo openssl x509 -req -in /etc/kubernetes/pki/etcd/etcd.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/etcd/etcd.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/etcd/etcd-openssl.cnf
```

```bash
sudo systemctl daemon-reload
sudo systemctl restart etcd
sudo systemctl status etcd
sudo journalctl -u etcd
```