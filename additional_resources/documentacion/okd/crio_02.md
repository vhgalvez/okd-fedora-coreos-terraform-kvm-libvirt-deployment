Documentación de Instalación y Configuración de CRI-O
1. Instalación de CRI-O
Paso 1: Descargar el Binario de CRI-O

bash
Copiar código
sudo wget -O /tmp/crio.tar.gz https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.3.tar.gz
Paso 2: Crear un Directorio Temporal

bash
Copiar código
sudo mkdir -p /tmp/crio
Paso 3: Extraer el Archivo Descargado

bash
Copiar código
sudo tar -xzf /tmp/crio.tar.gz -C /tmp/crio
Paso 4: Crear el Directorio de Instalación

bash
Copiar código
sudo mkdir -p /opt/bin/crio
Paso 5: Mover los Binarios a /opt/bin/crio/

bash
Copiar código
sudo mv /tmp/crio/cri-o/bin/* /opt/bin/crio/
Paso 6: Verificar la Instalación

bash
Copiar código
/opt/bin/crio/crio --version
2. Configuración de CRI-O
Archivo de Configuración (/etc/crio/crio.conf):

Primero, asegúrate de que el directorio /etc/crio/ exista:

bash
Copiar código
sudo mkdir -p /etc/crio/
Luego, edita el archivo de configuración:

bash
Copiar código
sudo nano /etc/crio/crio.conf
Y agrega el siguiente contenido:

ini
Copiar código
[crio]
log_level = "debug"
root = "/var/lib/crio"
runroot = "/var/run/crio"
log_dir = "/var/log/crio/pods"
version_file = "/var/run/crio/version"
clean_shutdown_file = "/var/lib/crio/clean.shutdown"

[crio.api]
listen = "/var/run/crio/crio.sock"
stream_address = "127.0.0.1"
stream_port = "0"
grpc_max_send_msg_size = 83886080
grpc_max_recv_msg_size = 83886080

[crio.runtime]
default_runtime = "runc"
no_pivot = false
decryption_keys_path = "/etc/crio/keys/"
cgroup_manager = "systemd"
drop_infra_ctr = true
infra_ctr_cpuset = ""
shared_cpuset = ""
namespaces_dir = "/var/run"
enable_criu_support = true
pinns_path = "/opt/bin/crio/pinns"

[crio.runtime.runtimes.runc]
runtime_path = "/opt/bin/crio/crio-runc"
runtime_type = "oci"
runtime_root = "/run/runc"

[crio.image]
pause_image = "k8s.gcr.io/pause:3.2"
image_volumes = "mkdir"

[crio.network]
network_dir = "/etc/cni/net.d/"
plugin_dirs = ["/opt/cni/bin/"]
Archivo del Servicio (/etc/systemd/system/crio.service):

ini
Copiar código
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
3. Verificación del Servicio
Estado del Servicio:

bash
Copiar código
sudo systemctl status crio
Verificación de Logs:

bash
Copiar código
sudo journalctl -u crio -f
Reiniciar el Servicio (si se realizan cambios):

bash
Copiar código
sudo systemctl restart crio
sudo systemctl status crio
4. Instalación y Configuración de conmon
Descargar conmon:

bash
Copiar código
wget https://github.com/containers/conmon/releases/download/v2.1.12/conmon.amd64
Mover y Renombrar el Archivo Descargado:

bash
Copiar código
sudo mkdir -p /opt/bin/crio
sudo mv conmon.amd64 /opt/bin/crio/conmon
Dar Permisos de Ejecución:

bash
Copiar código
sudo chmod +x /opt/bin/crio/conmon
Actualizar crio.conf para Reflejar la Ruta Correcta de conmon

Asegúrate de que la siguiente línea esté correctamente establecida en /etc/crio/crio.conf bajo la sección [crio.runtime]:

ini
Copiar código
conmon = "/opt/bin/crio/conmon"
Recargar y Reiniciar CRI-O:

bash
Copiar código
sudo systemctl daemon-reload
sudo systemctl restart crio
Verificar el Estado de CRI-O:

bash
Copiar código
sudo systemctl status crio
Confirmar los Binarios de CRI-O y Permisos:

bash
Copiar código
ls -l /opt/bin/crio/
Con estos pasos, CRI-O y conmon deberían estar correctamente instalados y configurados en tu sistema. Si encuentras algún problema, revisa los logs y la configuración de tu entorno para resolver cualquier inconveniente.


https://github.com/cri-o/cri-o/releases
https://github.com/containers/conmon/releases
