Documento 1: Instalación y Configuración del Servicio etcd
Paso 1: Crear el archivo de servicio para etcd
Primero, definimos el archivo de servicio para etcd:

bash
Copiar código
sudo vim /etc/systemd/system/etcd.service
Contenido del archivo etcd.service:

bash
Copiar código
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
Environment="ETCD_LISTEN_PEER_URLS=https://10.17.4.22:2380"
Environment="ETCD_LISTEN_CLIENT_URLS=https://10.17.4.22:2379,https://127.0.0.1:2379"
Environment="ETCD_ADVERTISE_CLIENT_URLS=https://10.17.4.22:2379"
Environment="ETCD_CERT_FILE=/etc/kubernetes/pki/etcd/etcd.crt"
Environment="ETCD_KEY_FILE=/etc/kubernetes/pki/etcd/etcd.key"
Environment="ETCD_TRUSTED_CA_FILE=/etc/kubernetes/pki/etcd/ca.crt"
Environment="ETCD_CLIENT_CERT_AUTH=true"
ExecStart=/opt/bin/etcd
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
Paso 2: Generación de los certificados para etcd
2.1 Crear la clave privada y el certificado de la CA para etcd
bash
Copiar código
sudo mkdir -p /etc/kubernetes/pki/etcd

# Generar la clave privada de la CA
sudo openssl genpkey -algorithm RSA -out /etc/kubernetes/pki/etcd/ca.key -pkeyopt rsa_keygen_bits:2048

# Crear el certificado de la CA
sudo openssl req -x509 -new -nodes -key /etc/kubernetes/pki/etcd/ca.key -subj "/CN=etcd-ca" -days 3650 -out /etc/kubernetes/pki/etcd/ca.crt
2.2 Generar la clave privada para el servidor etcd
bash
Copiar código
sudo openssl genpkey -algorithm RSA -out /etc/kubernetes/pki/etcd/etcd.key -pkeyopt rsa_keygen_bits:2048
2.3 Crear la solicitud de firma de certificado (CSR) para etcd
bash
Copiar código
sudo openssl req -new -key /etc/kubernetes/pki/etcd/etcd.key -subj "/CN=etcd-server" -out /etc/kubernetes/pki/etcd/etcd.csr
2.4 Crear el archivo de configuración OpenSSL
bash
Copiar código
sudo tee /etc/kubernetes/pki/etcd/etcd-openssl.cnf <<EOF
[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = etcd
IP.1 = 127.0.0.1
IP.2 = 10.17.4.22  # Cambia por la IP de tu nodo etcd
EOF
2.5 Firmar el CSR con la CA para generar el certificado de etcd
bash
Copiar código
sudo openssl x509 -req -in /etc/kubernetes/pki/etcd/etcd.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/etcd/etcd.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/etcd/etcd-openssl.cnf
2.6 Cambiar los permisos de los certificados
bash
Copiar código
sudo chown etcd:etcd /etc/kubernetes/pki/etcd/*.*
sudo chmod 600 /etc/kubernetes/pki/etcd/*.key
sudo chmod 644 /etc/kubernetes/pki/etcd/*.crt
Paso 3: Iniciar y verificar el servicio etcd
bash
Copiar código
# Recargar systemd para reflejar los cambios
sudo systemctl daemon-reload

# Iniciar y habilitar el servicio etcd
sudo systemctl start etcd
sudo systemctl enable etcd

# Verificar el estado del servicio
sudo systemctl status etcd

# Ver los logs del servicio
sudo journalctl -u etcd -f
Documento 2: Instalación y Configuración del Servicio kube-apiserver
Paso 1: Crear los certificados de kube-apiserver
1.1 Crear la CA
bash
Copiar código
sudo openssl genrsa -out /etc/kubernetes/pki/ca.key 2048
sudo openssl req -x509 -new -nodes -key /etc/kubernetes/pki/ca.key -subj "/CN=kubernetes-ca" -days 3650 -out /etc/kubernetes/pki/ca.crt
1.2 Generar los certificados y claves privadas de kube-apiserver
Certificado del servidor
bash
Copiar código
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver.key -out /etc/kubernetes/pki/apiserver.csr -subj "/CN=kube-apiserver"
Crear el archivo de configuración para OpenSSL:

bash
Copiar código
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
IP.1 = 10.17.4.22  # Cambia por la IP de tu nodo kube-apiserver
IP.2 = 10.96.0.1
EOF
Generar el certificado para kube-apiserver:

bash
Copiar código
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 365 -extensions v3_req -extfile /etc/kubernetes/pki/v3_req.cnf
Certificado del cliente para etcd
bash
Copiar código
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-etcd-client.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -subj "/CN=apiserver-etcd-client" -out /etc/kubernetes/pki/apiserver-etcd-client.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt -days 365
Paso 2: Crear el archivo de servicio para kube-apiserver
bash
Copiar código
sudo vim /etc/systemd/system/kube-apiserver.service
Contenido del archivo de servicio:

bash
Copiar código
[Unit]
Description=Kubernetes API Server
Documentation=https://kubernetes.io/docs/concepts/overview/components/
After=network.target

[Service]
ExecStart=/opt/bin/kube-apiserver \
  --advertise-address=10.17.4.22 \
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
  --service-account-key-file=/etc/kubernetes/pki/sa.pub \
  --service-account-signing-key-file=/etc/kubernetes/pki/sa.key \
  --tls-cert-file=/etc/kubernetes/pki/apiserver.crt \
  --tls-private-key-file=/etc/kubernetes/pki/apiserver.key \
  --v=2
Restart=on-failure

[Install]
WantedBy=multi-user.target
Paso 3: Iniciar y verificar el servicio kube-apiserver
bash
Copiar código
# Recargar systemd para reflejar los cambios
sudo systemctl daemon-reload

# Iniciar y habilitar el servicio kube-apiserver
sudo systemctl start kube-apiserver
sudo systemctl enable kube-apiserver

# Verificar el estado del servicio
sudo systemctl status kube-apiserver

# Ver los logs del servicio
sudo journalctl -u kube-apiserver -f