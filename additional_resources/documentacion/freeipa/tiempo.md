Configuración de NTP en FreeIPA (Servidor) y Clientes
Configuración del Servidor NTP (FreeIPA)
Paso 1: Instalar chrony
En el nodo donde se encuentra instalado FreeIPA (servidor 10.17.3.11):

Instala chrony si no está instalado:

bash
Copiar código
sudo dnf install chrony -y
Habilita y arranca el servicio de chronyd:

bash
Copiar código
sudo systemctl enable chronyd --now
sudo systemctl start chronyd
Asegúrate de que chrony está configurado para usar los servidores correctos. Edita el archivo de configuración /etc/chrony.conf:

bash
Copiar código
sudo nano /etc/chrony.conf
Agrega o modifica las siguientes líneas para usar servidores NTP públicos y la IP de FreeIPA como fuente interna:

ini
Copiar código
pool europe.pool.ntp.org iburst
server 10.17.3.11 iburst
Reinicia el servicio para aplicar los cambios:

bash
Copiar código
sudo systemctl restart chronyd
Verifica el estado de sincronización:

bash
Copiar código
sudo chronyc sources -v
sudo systemctl status chronyd
Habilita el puerto NTP en el firewall:

bash
Copiar código
sudo firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --reload
Paso 2: Verificar la Sincronización de la Hora
Verifica que el servicio de chrony está funcionando correctamente:

bash
Copiar código
sudo chronyc sources -v
Verifica que el puerto 123 está abierto para NTP:

bash
Copiar código
sudo netstat -uln | grep :123
Configuración de los Clientes NTP (Bootstrap, Master, Workers)
Paso 1: Configurar systemd-timesyncd
En los nodos clientes (Bootstrap, Master, Workers):

Verifica la configuración de systemd-timesyncd. Abre el archivo /etc/systemd/timesyncd.conf y configura la IP del servidor NTP (FreeIPA) como la fuente principal:

bash
Copiar código
sudo nano /etc/systemd/timesyncd.conf
Modifica el archivo para incluir el servidor NTP (10.17.3.11):

ini
Copiar código
[Time]
NTP=10.17.3.11
FallbackNTP=0.pool.ntp.org
Guarda el archivo y reinicia el servicio para aplicar los cambios:

bash
Copiar código
sudo systemctl restart systemd-timesyncd
Habilita systemd-timesyncd para que arranque al iniciar el sistema:

bash
Copiar código
sudo systemctl enable systemd-timesyncd
Paso 2: Verificar Sincronización en el Cliente
Verifica el estado de la sincronización en los nodos clientes:

bash
Copiar código
timedatectl status
Debes ver algo similar a:

bash
Copiar código
System clock synchronized: yes
NTP service: active
Paso 3: Comprobación Final
Verifica que los nodos estén sincronizando la hora correctamente con el servidor NTP (10.17.3.11):

Realiza un ping desde cualquier cliente al servidor NTP:

bash
Copiar código
ping -c 4 10.17.3.11
Usa timedatectl para verificar que el reloj del sistema está sincronizado:

bash
Copiar código
timedatectl status
Resumen
Servidor FreeIPA (10.17.3.11):

Instalar y configurar chrony.
Asegurar que el puerto 123 está abierto en el firewall.
Verificar la sincronización.
Clientes (Bootstrap, Master, Workers):

Configurar systemd-timesyncd para usar el servidor NTP (10.17.3.11).
Reiniciar y habilitar el servicio de sincronización.
Verificar que la sincronización esté activa con timedatectl.
Este procedimiento garantiza que todos los nodos se sincronicen con el servidor NTP central y que se mantenga la consistencia horaria en todo el sistema.