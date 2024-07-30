# Configuración de Nodos Master y Worker

----------------------------------------
Para configurar los nodos master y worker y preparar el entorno para la instalación de OKD (OpenShift Kubernetes Distribution), se deben seguir una serie de pasos detallados, incluyendo la generación de certificados y la configuración de los servicios necesarios. A continuación, se describen los pasos y configuraciones necesarias para cada tipo de nodo.

Generación de Claves y Certificados

-----------------------------------

Primero, necesitamos generar varios certificados y claves que serán utilizados por los diferentes componentes de Kubernetes.

# Crear directorios necesarios

```bash
sudo mkdir -p /etc/kubernetes/pki/etcd
```

# Generar clave y certificado de la CA

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/ca.key 2048
sudo openssl req -x509 -new -nodes -key /etc/kubernetes/pki/ca.key -subj "/CN=kube-ca" -days 10000 -out /etc/kubernetes/pki/ca.crt
```

# Generar clave y certificado para el API Server
    
```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver.key -subj "/CN=kube-apiserver" -out /etc/kubernetes/pki/apiserver.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 10000
```

# Generar clave y certificado para etcd

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/etcd/ca.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/etcd/ca.key -subj "/CN=etcd-ca" -out /etc/kubernetes/pki/etcd/ca.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/etcd/ca.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/etcd/ca.crt -days 10000
```

# Generar clave y certificado para el cliente de etcd

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-etcd-client.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -subj "/CN=etcd-client" -out /etc/kubernetes/pki/apiserver-etcd-client.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt -days 10000
```

# Generar clave y certificado para el cliente kubelet

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-kubelet-client.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-kubelet-client.key -subj "/CN=kubelet-client" -out /etc/kubernetes/pki/apiserver-kubelet-client.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-kubelet-client.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-kubelet-client.crt -days 10000
```

# Generar clave y certificado de servicio de cuenta

```bash
sudo openssl genrsa -out /etc/kubernetes/pki/sa.key 2048
sudo openssl rsa -in /etc/kubernetes/pki/sa.key -pubout -out /etc/kubernetes/pki/sa.pub
```
