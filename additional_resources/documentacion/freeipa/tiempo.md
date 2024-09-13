# Configuración de NTP en FreeIPA (Servidor) y Clientes

Este documento detalla los pasos para configurar el servidor NTP en FreeIPA y los clientes del clúster utilizando **chrony** y **systemd-timesyncd** para asegurar una sincronización horaria precisa.

## Configuración del Servidor NTP (FreeIPA)

### Paso 1: Instalar chrony

1. En el nodo donde se encuentra instalado **FreeIPA** (servidor con IP `10.17.3.11`), instala **chrony** si no está instalado:

   ```bash
   sudo dnf install chrony -y
    ```

Habilita y arranca el servicio de chronyd:

bash
Copiar código
sudo systemctl enable chronyd --now
sudo systemctl start chronyd
Configura chrony para usar los servidores NTP correctos. Edita el archivo /etc/chrony.conf:

bash
Copiar código
sudo nano /etc/chrony.conf
Asegúrate de agregar o modificar las siguientes líneas para usar servidores NTP públicos y la IP del servidor FreeIPA como fuente interna:

ini
Copiar código
pool europe.pool.ntp.org iburst
server 10.17.3.11 iburst
Reinicia el servicio para aplicar los cambios:

bash
Copiar código
sudo systemctl restart chronyd
Verifica el estado de la sincronización:

bash
Copiar código
sudo chronyc sources -v
sudo systemctl status chronyd
Paso 2: Configurar el Firewall
Habilita el puerto NTP (123) en el firewall:

bash
Copiar código
sudo firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --reload
Paso 3: Verificar la Sincronización de la Hora
Verifica que el servicio de chrony está funcionando correctamente:

bash
Copiar código
sudo chronyc sources -v
Asegúrate de que el puerto NTP está abierto:

bash
Copiar código
sudo netstat -uln | grep :123
Configuración de los Clientes NTP (Bootstrap, Master, Workers)
Paso 1: Configurar systemd-timesyncd
En los nodos clientes (Bootstrap, Master, Workers), verifica y edita la configuración de systemd-timesyncd. Abre el archivo /etc/systemd/timesyncd.conf:

bash
Copiar código
sudo nano /etc/systemd/timesyncd.conf
Modifica el archivo para incluir la IP del servidor NTP (FreeIPA):

ini
Copiar código
[Time]
NTP=10.17.3.11
FallbackNTP=0.pool.ntp.org
Guarda los cambios y reinicia el servicio:

bash
Copiar código
sudo systemctl restart systemd-timesyncd
Habilita systemd-timesyncd para que arranque al iniciar el sistema:

bash
Copiar código
sudo systemctl enable systemd-timesyncd
Paso 2: Verificar la Sincronización en los Clientes
Verifica el estado de la sincronización en los nodos clientes:

bash
Copiar código
timedatectl status
Deberías ver algo similar a:

bash
Copiar código
System clock synchronized: yes
NTP service: active
Paso 3: Comprobación Final
Verifica que los nodos estén sincronizados correctamente con el servidor NTP (FreeIPA 10.17.3.11):

Realiza un ping desde cualquier cliente al servidor NTP:

bash
Copiar código
ping -c 4 10.17.3.11
Usa timedatectl para verificar que el reloj del sistema esté sincronizado:

bash
Copiar código
timedatectl status
Resumen
Servidor FreeIPA (10.17.3.11):
Instalar y configurar chrony.
Asegurar que el puerto NTP (123) esté abierto en el firewall.
Verificar la sincronización con chronyc sources -v.
Clientes (Bootstrap, Master, Workers):
Configurar systemd-timesyncd para usar el servidor NTP (10.17.3.11).
Reiniciar y habilitar el servicio de sincronización.
Verificar la sincronización usando timedatectl status.
Este procedimiento asegura que todos los nodos se sincronicen con el servidor NTP central, manteniendo la consistencia horaria en todo el sistema.
