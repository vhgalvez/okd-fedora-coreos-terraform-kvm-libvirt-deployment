
# Configuración de NTP en FreeIPA (Servidor) y Clientes

Este documento detalla los pasos para configurar el servidor NTP en FreeIPA y los clientes del clúster utilizando chrony y systemd-timesyncd para asegurar una sincronización horaria precisa.

## Configuración del Servidor NTP (FreeIPA)

### Paso 1: Instalar chrony
En el nodo donde se encuentra instalado FreeIPA (servidor con IP 10.17.3.11), instala chrony si no está instalado:

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
Guía para Verificación y Configuración de DNS en FreeIPA
Paso 1: Comprueba la Resolución DNS
Después de haber configurado los reenviadores y reiniciado named, comprueba si la resolución DNS funciona correctamente.

bash
Copiar código
# Verifica la resolución DNS con curl
curl https://google.com

# Verifica la resolución DNS con ping
ping google.com
Paso 2: Verifica el Archivo /etc/resolv.conf
Es importante que el archivo /etc/resolv.conf esté correctamente configurado. Este archivo debe apuntar a tu servidor DNS local (FreeIPA) y, opcionalmente, a servidores DNS externos como Google DNS.

bash
Copiar código
# Visualiza el contenido de /etc/resolv.conf
cat /etc/resolv.conf
El archivo debe verse similar a lo siguiente:

bash
Copiar código
nameserver 127.0.0.1  # O la IP de tu servidor FreeIPA
nameserver 8.8.8.8  # Google DNS
Si el archivo no está correctamente configurado, edítalo:

bash
Copiar código
# Edita /etc/resolv.conf
sudo nano /etc/resolv.conf
Agrega las siguientes líneas (modifica según sea necesario):

bash
Copiar código
nameserver 127.0.0.1
nameserver 8.8.8.8
Guarda los cambios y cierra el archivo.

Paso 3: Prueba la Conectividad Nuevamente
Una vez que hayas configurado correctamente el archivo /etc/resolv.conf, prueba de nuevo la resolución de nombres.

bash
Copiar código
# Prueba la conectividad con curl
curl https://google.com

# Prueba la conectividad con ping
ping google.com
Si todo está correctamente configurado, deberías poder resolver los nombres de dominio sin problemas.

Paso 4: Verifica los Logs si Persiste el Problema
Si el problema persiste, es recomendable revisar los logs de BIND para obtener más detalles sobre posibles errores de configuración de DNS.

bash
Copiar código
# Verifica los logs del servicio named
sudo journalctl -u named
Los logs deberían proporcionar información adicional sobre cualquier fallo relacionado con la configuración de DNS en tu sistema.

Con esta guía puedes asegurar que la configuración de NTP y DNS en tu servidor FreeIPA esté correctamente establecida, y que los clientes estén correctamente sincronizados tanto en tiempo como en resolución de nombres.