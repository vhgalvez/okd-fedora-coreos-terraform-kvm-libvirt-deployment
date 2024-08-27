Para instalar y configurar un servidor web Nginx utilizando Docker Compose en un sistema basado en Linux, sigue los pasos detallados a continuación. Este tutorial cubre la creación de un contenedor Docker para Nginx y su configuración a través de Docker Compose.

Paso 1: Preparar el Entorno de Trabajo
Primero, crea un directorio de trabajo donde se almacenarán todos los archivos necesarios para la configuración del servidor Nginx.

bash
Copiar código
mkdir ~/nginx-docker
cd ~/nginx-docker
Paso 2: Crear el Archivo docker-compose.yml
Crea un archivo docker-compose.yml en el directorio de trabajo. Este archivo definirá los servicios que se ejecutarán en contenedores Docker, en este caso, Nginx.

bash
Copiar código
nano docker-compose.yml
Dentro del archivo docker-compose.yml, añade el siguiente contenido:

yaml
Copiar código
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
      - ./certificates:/etc/nginx/certificates:ro
    restart: always
Este archivo configura Nginx para exponer los puertos 80 (HTTP) y 443 (HTTPS) y monta tres volúmenes:

nginx.conf: Archivo de configuración principal de Nginx.
html: Directorio donde se almacenarán los archivos HTML que se servirán.
certificates: Directorio para los certificados SSL.
Paso 3: Configurar Nginx
A continuación, crea un archivo de configuración para Nginx llamado nginx.conf en el mismo directorio.

bash
Copiar código
nano nginx.conf
Añade la siguiente configuración básica para servir contenido estático y manejar conexiones HTTPS:

nginx
Copiar código
events {}

http {
    server {
        listen 80;
        server_name localhost;

        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        listen 443 ssl;
        ssl_certificate /etc/nginx/certificates/server.crt;
        ssl_certificate_key /etc/nginx/certificates/server.key;
    }
}
Paso 4: Crear el Directorio de Contenido HTML
Crea un directorio html para almacenar el archivo index.html que se servirá por Nginx.

bash
Copiar código
mkdir html
echo '<h1>Welcome to Nginx!</h1>' > html/index.html
Paso 5: Iniciar el Servidor Nginx
Ahora puedes iniciar el servidor Nginx utilizando Docker Compose. Asegúrate de estar en el directorio donde se encuentra el archivo docker-compose.yml.

bash
Copiar código
docker-compose up -d
El parámetro -d asegura que el contenedor se ejecute en segundo plano.

Paso 6: Verificar los Logs y Detener el Servidor
Puedes verificar los logs para asegurarte de que todo esté funcionando correctamente:

bash
Copiar código
docker-compose logs -f
Si deseas detener el servidor en algún momento, utiliza el siguiente comando:

bash
Copiar código
docker-compose down
Paso 7: Instalar Git y Clonar un Repositorio
Si necesitas clonar un repositorio para obtener más recursos o configuraciones, puedes instalar Git y clonar el repositorio requerido.

bash
Copiar código
sudo dnf install git
git clone https://github.com/vhgalvez/generate_certificates_cluster.git
Resumen y Explicación
Este tutorial te guía a través de la creación y configuración de un servidor Nginx utilizando Docker Compose. Los archivos de configuración (docker-compose.yml y nginx.conf) están diseñados para exponer un servidor web en los puertos 80 y 443, con soporte para HTTPS mediante certificados SSL. Además, se muestran comandos útiles para manejar el ciclo de vida del contenedor Docker y la instalación de Git para clonar repositorios adicionales.

Puedes nombrar este documento como "Guía para Configurar un Servidor Nginx con Docker Compose" o "Configuración de Nginx en Docker Compose: Paso a Paso" según prefieras.