markdown
Copiar código
# Instalación de Traefik en LoadBalancer1 utilizando Docker Compose

A continuación se detallan los pasos para instalar Traefik en la máquina LoadBalancer1 con IP `10.17.3.12`, dominio `loadbalancer1.cefaslocalserver.com`, y sistema operativo Rocky Linux 9.3.

## Paso 1: Preparar el Entorno

### Acceder al Servidor
Conéctese al servidor `loadbalancer1` mediante SSH:

```bash
ssh root@10.17.3.12
Actualizar el Sistema
Actualice los paquetes del sistema:

bash
Copiar código
sudo dnf update -y
Instalar Dependencias
Instale las dependencias necesarias:

bash
Copiar código
sudo dnf install -y epel-release
sudo dnf install -y wget vim
Paso 2: Instalar Docker
Instalar Docker
Siga estos pasos para instalar Docker en Rocky Linux:

bash
Copiar código
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
Iniciar y Habilitar Docker
Inicie el servicio de Docker y configúrelo para que se inicie automáticamente al arrancar el sistema:

bash
Copiar código
sudo systemctl start docker
sudo systemctl enable docker
Paso 3: Instalar Docker Compose
Descargar Docker Compose
Descargue Docker Compose usando curl:

bash
Copiar código
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
Dar Permisos de Ejecución
Asigne permisos de ejecución al binario descargado:

bash
Copiar código
sudo chmod +x /usr/local/bin/docker-compose
Verificar la Instalación
Verifique que Docker Compose esté instalado correctamente:

bash
Copiar código
/usr/local/bin/docker-compose --version
Añadir Docker Compose al PATH
Asegúrese de que Docker Compose esté en el PATH. Puede añadirlo temporalmente a su sesión actual:

bash
Copiar código
export PATH=$PATH:/usr/local/bin
Para añadirlo permanentemente, puede añadir la línea anterior al archivo .bashrc o .bash_profile de su usuario:

bash
Copiar código
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
Modificar el PATH para sudo
Edite el archivo /etc/sudoers para incluir /usr/local/bin en secure_path:

bash
Copiar código
sudo visudo
Modifique la línea Defaults secure_path para que se vea así:

plaintext
Copiar código
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
Paso 4: Configurar y Ejecutar Traefik con Docker Compose
Crear Directorio de Configuración de Traefik
Cree el directorio de configuración de Traefik:

bash
Copiar código
mkdir -p /etc/traefik
cd /etc/traefik
Crear el Archivo de Configuración traefik.toml
Cree el archivo traefik.toml con el siguiente contenido:

bash
Copiar código
vim /etc/traefik/traefik.toml
Contenido del archivo traefik.toml:

toml
Copiar código
[entryPoints]
  [entryPoints.http]
    address = ":80"
  [entryPoints.https]
    address = ":443"

[api]
  dashboard = true

[providers.docker]
  endpoint = "unix:///var/run/docker.sock"
  exposedByDefault = false

[log]
  level = "DEBUG"

[accessLog]

[certificatesResolvers.myresolver.acme]
  email = "your-email@example.com"
  storage = "acme.json"
  [certificatesResolvers.myresolver.acme.httpChallenge]
    entryPoint = "http"
Crear el Archivo acme.json
Cree el archivo acme.json y ajuste los permisos:

bash
Copiar código
touch /etc/traefik/acme.json
chmod 600 /etc/traefik/acme.json
Crear el Archivo docker-compose.yml
Cree el archivo docker-compose.yml con el siguiente contenido:

bash
Copiar código
vim /etc/traefik/docker-compose.yml
Contenido del archivo docker-compose.yml:

yaml
Copiar código
version: '3'

services:
  traefik:
    image: traefik:v2.3
    command:
      - --api.insecure=true
      - --providers.docker
      - --entrypoints.http.address=:80
      - --entrypoints.https.address=:443
      - --certificatesresolvers.myresolver.acme.email=your-email@example.com
      - --certificatesresolvers.myresolver.acme.storage=acme.json
      - --certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=http
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/traefik/traefik.toml:/traefik.toml
      - /etc/traefik/acme.json:/acme.json
    restart: always
Iniciar Traefik con Docker Compose
Navegue al directorio /etc/traefik y ejecute Docker Compose:

bash
Copiar código
cd /etc/traefik
sudo /usr/local/bin/docker-compose up -d
Paso 5: Verificar la Instalación
Verificar el Estado de Traefik
Puede verificar que el contenedor de Traefik esté en funcionamiento con:

bash
Copiar código
sudo docker ps
Acceder al Dashboard de Traefik
Abra un navegador web y acceda al dashboard de Traefik usando la IP pública o el dominio del servidor:

plaintext
Copiar código
http://10.17.3.12:8080/dashboard/
Paso 6: Configurar el Firewall
Abrir Puertos en el Firewall
Abra los puertos necesarios en el firewall:

bash
Copiar código
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload


Con estos pasos, habrás instalado y configurado Traefik en la máquina LoadBalancer1 utilizando Docker Compose.