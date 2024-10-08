
# Guía Completa para Configurar el Servidor Help

Este tutorial te guiará a través de los pasos necesarios para preparar el entorno, instalar Docker y Docker Compose, configurar un servidor Nginx utilizando Docker Compose, generar certificados SSL, y clonar un repositorio de Git en un servidor Linux basado en Rocky Linux.

## Paso 1: Preparar el Entorno

### 1.1 Acceder al Servidor
Conéctese al servidor `help` utilizando SSH:

```bash
sudo ssh -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift core@10.17.3.14 -p 22
```

### 1.2 Actualizar el Sistema
Actualice todos los paquetes del sistema:

```bash
sudo dnf update -y && sudo dnf upgrade -y
```

### 1.3 Instalar Dependencias
Instale las dependencias necesarias:

```bash
sudo dnf install -y epel-release
sudo dnf install -y wget vim
```

## Paso 2: Instalar Docker

### 2.1 Instalar Docker
Agregue el repositorio e instale Docker:

```bash
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
```

### 2.2 Iniciar y Habilitar Docker
Inicie el servicio de Docker y configúrelo para que se inicie automáticamente al arrancar el sistema:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## Paso 3: Instalar Docker Compose

### 3.1 Descargar Docker Compose
Descargue Docker Compose:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

### 3.2 Dar Permisos de Ejecución
Asigne permisos de ejecución:

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

### 3.3 Verificar la Instalación
Verifique que Docker Compose esté instalado:

```bash
/usr/local/bin/docker-compose --version
```

### 3.4 Añadir Docker Compose al PATH
Agregue Docker Compose al PATH:

```bash
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
```

### 3.5 Modificar el PATH para sudo
Edite `/etc/sudoers` para incluir `/usr/local/bin`:

```bash
sudo visudo
```

Modifique la línea de `secure_path`:

```bash
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
```

## Paso 4: Configurar Nginx con Docker Compose

### 4.1 Crear un Directorio para Nginx
Cree un directorio de trabajo:

```bash
mkdir ~/nginx-docker
cd ~/nginx-docker
```

### 4.2 Crear el Archivo `docker-compose.yml`
Cree y edite el archivo:

```bash
nano docker-compose.yml
```

Agregue el siguiente contenido:

```yaml
version: '3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/usr/share/nginx/html:ro
      - ./certificates:/etc/nginx/certificates-exposed:ro
      - ./nginx-certs:/etc/nginx/certificates:ro
    restart: always
```

### 4.3 Crear el Archivo de Configuración de Nginx
Cree el archivo `nginx.conf`:

```bash
nano nginx.conf
```

Añada la configuración para servir contenido estático y manejar SSL:

```nginx
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name localhost;

        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        location /certificates/ {
            alias /etc/nginx/certificates-exposed/;
            autoindex on;
            allow 10.17.3.0/24;
            allow 10.17.4.0/24;
            deny all;
        }

        listen 443 ssl;
        ssl_certificate /etc/nginx/certificates/server.crt;
        ssl_certificate_key /etc/nginx/certificates/server.key;
    }
}
```

### 4.4 Crear el Directorio de HTML
Cree el directorio y el archivo `index.html`:

```bash
mkdir html
echo '<h1>Welcome to Nginx!</h1>' > html/index.html
```

### 4.5 Iniciar el Servidor Nginx
Ejecute Docker Compose:

```bash
docker-compose up -d
```

### 4.6 Verificar los Logs y Detener el Servidor
Verifique los logs de Docker:

```bash
docker-compose logs -f
```

Para detener el servidor:

```bash
docker-compose down
```

## Paso 5: Generar Certificado SSL

### 5.1 Crear el Directorio para los Certificados
Cree un directorio para almacenar los certificados:

```bash
mkdir /home/core/nginx-docker/nginx-certs
```

### 5.2 Generar el Certificado SSL
Genere un certificado auto-firmado:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/core/nginx-docker/nginx-certs/server.key -out /home/core/nginx-docker/nginx-certs/server.crt -subj "/CN=localhost"
```

## Paso 6: Clonar Repositorio de Git

### 6.1 Instalar Git
Instale Git en el servidor:

```bash
sudo dnf install git
```

### 6.2 Clonar el Repositorio
Clone el repositorio necesario:

```bash
git clone https://github.com/vhgalvez/generate_certificates_cluster.git
```

## Resumen

Este tutorial cubre la instalación y configuración de Docker, Docker Compose, y Nginx con soporte para HTTPS mediante certificados SSL. Además, muestra cómo exponer directorios específicos a través de Nginx y utilizar Docker Compose para gestionar contenedores de manera eficiente.

---

### Posibles Mejoras:
- **Seguridad**: Considera implementar medidas de seguridad adicionales, como la autenticación básica para proteger el acceso a los certificados expuestos.
- **Automatización**: Puedes crear scripts adicionales para automatizar la generación y renovación de certificados.

### Nombres Sugeridos para el Documento:
- "Guía para Configurar un Servidor Nginx con Docker Compose"
- "Configuración de Nginx en Docker Compose: Paso a Paso"

---

**Nota:** Asegúrate de tener los permisos adecuados para ejecutar los comandos y acceder a los directorios mencionados en esta guía. Además, adapta las direcciones IP y rutas según las necesidades específicas de tu entorno.
