
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
enforceNodeAllocatable: []
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

### crio.conf file


```bash

sudo tee /etc/systemd/system/crio.service > /dev/null <<EOF
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
EOF
```




### kubelet.service file

```bash
sudo tee /etc/systemd/system/kubelet.service > /dev/null <<EOF

[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/bin/kubelet \
    --kubeconfig=/etc/kubernetes/kubelet.conf \
    --config=/etc/kubernetes/kubelet-config.yaml \
    --container-runtime=remote \
    --container-runtime-endpoint=unix:///var/run/crio/crio.sock \
    --fail-swap-on=false \
    --cgroup-driver=systemd
Restart=always
StartLimitIntervalSec=0
RestartSec=10
CPUAccounting=true
MemoryAccounting=true
# Ensure kubelet has necessary permissions
ExecStartPre=/sbin/sysctl -w net.ipv4.ip_forward=1
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/systemd/system.slice/kubelet.service
# Commented out the problematic mount line to prevent errors
# ExecStartPre=/bin/mount --bind /sys/fs/cgroup/systemd/system.slice/kubelet.service /sys/fs/cgroup/systemd/system.slice/kubelet.service

[Install]
WantedBy=multi-user.target
EOF
```

sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet
sudo systemctl restart kubelet


```bash
sudo tee /etc/systemd/system/kubelet.service > /dev/null <<EOF

[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/bin/kubelet \
    --kubeconfig=/etc/kubernetes/kubelet.conf \
    --config=/etc/kubernetes/kubelet-config.yaml \
    --container-runtime=remote \
    --container-runtime-endpoint=unix:///var/run/crio/crio.sock \
    --fail-swap-on=false \
    --cgroup-driver=systemd
Restart=always
StartLimitIntervalSec=0
RestartSec=10
CPUAccounting=true
MemoryAccounting=true
# Ensure kubelet has necessary permissions
ExecStartPre=/sbin/sysctl -w net.ipv4.ip_forward=1
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/systemd/system.slice/kubelet.service
ExecStartPre=/bin/mount --bind /sys/fs/cgroup/systemd/system.slice/kubelet.service /sys/fs/cgroup/systemd/system.slice/kubelet.service

[Install]
WantedBy=multi-user.target
EOF
```


sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet
sudo systemctl restart kubelet

________________________________________________________________________________________________________________________
Clasificación y Explicación de Certificados en un Clúster Kubernetes
En un clúster Kubernetes, los nodos se dividen principalmente en tres tipos: Master, Worker, y Bootstrap. Cada uno de estos nodos tiene diferentes roles, y por lo tanto, requieren diferentes certificados para asegurar la comunicación y la autenticidad en el clúster.

A continuación, se clasifican los certificados según los nodos y se explica cuál es su propósito y dónde deben estar ubicados.

1. Certificados que Deben Estar en Todos los Nodos (Masters, Workers, Bootstrap)
Estos certificados son necesarios en todos los nodos, ya que aseguran la autenticidad y la comunicación segura entre los componentes del clúster.

CA Certificate (ca.crt)

Ubicación: /etc/kubernetes/pki/ca.crt
Propósito: Este certificado es la autoridad de certificación para todo el clúster. Todos los nodos (Masters, Workers, Bootstrap) utilizan este certificado para verificar otros certificados.
Kubelet Certificate (kubelet.crt)

Ubicación: /etc/kubernetes/pki/kubelet.crt
Propósito: Utilizado por el kubelet en cada nodo para autenticarse con el API server. Esto asegura que el nodo es legítimo y está autorizado a unirse al clúster.
Kubelet Key (kubelet.key)

Ubicación: /etc/kubernetes/pki/kubelet.key
Propósito: Es la clave privada correspondiente al certificado del kubelet (kubelet.crt). Permite que el nodo firme su identidad al comunicarse con el API server.
2. Certificados Específicos para los Nodos Master
Los nodos Master tienen responsabilidades adicionales, como administrar el API server, el controlador, y etcd. Por lo tanto, requieren certificados adicionales.

API Server Certificate (apiserver.crt)

Ubicación: /etc/kubernetes/pki/apiserver.crt
Propósito: Utilizado por el API server en los nodos Master para autenticarse con los clientes (como kubectl y otros componentes). Este certificado asegura que la comunicación con el API server es segura.
API Server Key (apiserver.key)

Ubicación: /etc/kubernetes/pki/apiserver.key
Propósito: La clave privada correspondiente al certificado del API server. Es utilizada por el API server para firmar y asegurar las comunicaciones.
Service Account Key Pair (sa.key, sa.pub)

Ubicación: /etc/kubernetes/pki/sa.key, /etc/kubernetes/pki/sa.pub
Propósito: Utilizado por el API server y el controlador de cuentas de servicio para firmar y verificar los tokens de servicio dentro del clúster.
Etcd Certificates

Etcd Server Certificate (etcd.crt)
Ubicación: /etc/kubernetes/pki/etcd/etcd.crt
Propósito: Asegura la comunicación dentro del clúster de etcd en los nodos Master.
Etcd Server Key (etcd.key)
Ubicación: /etc/kubernetes/pki/etcd/etcd.key
Propósito: Clave privada utilizada por el servidor etcd para firmar y asegurar las comunicaciones.
Etcd CA Certificate (etcd/ca.crt)
Ubicación: /etc/kubernetes/pki/etcd/ca.crt
Propósito: Autoridad de certificación para los certificados utilizados en el clúster de etcd.
API Server Etcd Client Certificates

API Server Etcd Client Certificate (apiserver-etcd-client.crt)
Ubicación: /etc/kubernetes/pki/apiserver-etcd-client.crt
Propósito: Utilizado por el API server para autenticarse con el clúster de etcd.
API Server Etcd Client Key (apiserver-etcd-client.key)
Ubicación: /etc/kubernetes/pki/apiserver-etcd-client.key
Propósito: Clave privada utilizada por el API server para autenticarse con el clúster de etcd.
3. Certificados Específicos para el Nodo Bootstrap
El nodo Bootstrap es utilizado para iniciar el clúster y luego su rol es reemplazado por los nodos Master. Por lo tanto, puede requerir los mismos certificados que los Masters inicialmente, pero una vez que el clúster está configurado, el nodo Bootstrap se puede eliminar o reintegrar con un rol diferente.

API Server Certificate (apiserver.crt)
API Server Key (apiserver.key)
Etcd Certificates (etcd.crt, etcd.key, etcd/ca.crt)
API Server Etcd Client Certificates (apiserver-etcd-client.crt, apiserver-etcd-client.key)
Resumen de Certificados por Nodo
Todos los Nodos (Masters, Workers, Bootstrap):

ca.crt
kubelet.crt, kubelet.key
Nodos Master (además de los anteriores):

apiserver.crt, apiserver.key
sa.key, sa.pub
etcd.crt, etcd.key, etcd/ca.crt
apiserver-etcd-client.crt, apiserver-etcd-client.key
Nodo Bootstrap (al iniciar el clúster):

Inicialmente: Los mismos certificados que los nodos Master.
Posteriormente: El nodo puede ser eliminado o reintegrado con los certificados básicos (ca.crt, kubelet.crt, kubelet.key) si sigue en operación con un rol diferente.
Este esquema de clasificación y distribución asegura que cada nodo tiene los certificados necesarios para su función en el clúster Kubernetes.