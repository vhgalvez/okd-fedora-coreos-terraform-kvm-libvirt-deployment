#!/bin/bash
set -euo pipefail

CERT_DIR="/etc/kubernetes/pki"

# Crear directorio para los certificados si no existe
sudo mkdir -p ${CERT_DIR}
sudo chmod 700 ${CERT_DIR}

# Generar la clave privada de la CA y el certificado de la CA
sudo openssl genpkey -algorithm RSA -out ${CERT_DIR}/ca.key -pkeyopt rsa_keygen_bits:2048
sudo openssl req -x509 -new -nodes -key ${CERT_DIR}/ca.key -sha256 -days 3650 -out ${CERT_DIR}/ca.crt -subj "/CN=Kubernetes-CA"

# Función para generar certificados por nodo
generate_cert_for_node() {
  local NODE_NAME=$1
  local NODE_IP=$2

  # Generar clave privada para el nodo
  sudo openssl genpkey -algorithm RSA -out ${CERT_DIR}/${NODE_NAME}.key -pkeyopt rsa_keygen_bits:2048

  # Crear un archivo de configuración para openssl
  cat > ${CERT_DIR}/${NODE_NAME}-openssl.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = ${NODE_NAME}

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[alt_names]
IP.1 = ${NODE_IP}
EOF

  # Generar CSR (Certificate Signing Request) y firmar el certificado con la CA
  sudo openssl req -new -key ${CERT_DIR}/${NODE_NAME}.key -out ${CERT_DIR}/${NODE_NAME}.csr -config ${CERT_DIR}/${NODE_NAME}-openssl.cnf
  sudo openssl x509 -req -in ${CERT_DIR}/${NODE_NAME}.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial -out ${CERT_DIR}/${NODE_NAME}.crt -days 365 -extensions v3_req -extfile ${CERT_DIR}/${NODE_NAME}-openssl.cnf
}

# Generar certificados para cada nodo
for NODE in $(terraform output -json ip_addresses | jq -r 'keys[]'); do
  IP=$(terraform output -json ip_addresses | jq -r --arg node "$NODE" '.[$node]')
  generate_cert_for_node $NODE $IP
done

# Ajustar permisos de los certificados
sudo chmod 600 ${CERT_DIR}/*.key
sudo chmod 644 ${CERT_DIR}/*.crt
sudo chown root:root ${CERT_DIR}/*