Configuración de NTP con Chrony usando FreeIPA como servidor NTP
Índice
Introducción
Configuración del servidor NTP en FreeIPA
Configuración de los clientes NTP
Verificación de sincronización
Configuración manual de cliente NTP
Conclusión
1. Introducción
El Protocolo de Tiempo de Red (NTP) es crucial para mantener la hora exacta entre todas las máquinas en una red. Aquí, usaremos chrony para configurar FreeIPA como el servidor NTP, y todas las demás máquinas en la red (Bastion, Helper, Masters, Workers, etc.) se sincronizarán con FreeIPA.

2. Configuración del servidor NTP en FreeIPA
Paso 1: Verifica la configuración del archivo de chrony en FreeIPA
El archivo de configuración de chrony en el servidor FreeIPA se encuentra en /etc/chrony.conf. Necesitamos asegurarnos de que chrony esté configurado para permitir el acceso a otros dispositivos de la red.

Abre el archivo de configuración de chrony en FreeIPA:

bash
Copiar código
sudo nano /etc/chrony.conf
Agrega la línea siguiente para permitir el acceso desde la red 10.17.x.x:

bash
Copiar código
allow 10.17.0.0/16
Esta línea permitirá que todas las máquinas de la red 10.17.x.x utilicen el servidor FreeIPA como fuente de tiempo.

Guarda los cambios y cierra el archivo.

Paso 2: Reinicia el servicio chronyd
Para aplicar los cambios en la configuración, reinicia el servicio chronyd:

bash
Copiar código
sudo systemctl restart chronyd
Paso 3: Verifica el estado del servicio chronyd
Asegúrate de que el servicio chronyd esté corriendo sin problemas:

bash
Copiar código
sudo systemctl status chronyd
3. Configuración de los clientes NTP
En todas las demás máquinas de la red (Bastion, Helper, Masters, Workers, etc.), debes configurarlas para que apunten al servidor FreeIPA como su fuente NTP.

Paso 1: Edita el archivo de configuración chrony.conf
En cada una de las máquinas clientes, sigue estos pasos para apuntarlas al servidor NTP FreeIPA.

Abre el archivo de configuración de chrony:

bash
Copiar código
sudo nano /etc/chrony.conf
Añade o modifica la siguiente línea para que el servidor FreeIPA sea la fuente de tiempo:

bash
Copiar código
server 10.17.3.11 iburst
Esto configurará FreeIPA (IP: 10.17.3.11) como el servidor NTP principal para la máquina cliente.

Guarda los cambios y cierra el archivo.

Paso 2: Reinicia el servicio chronyd en cada cliente
Reinicia el servicio chronyd en cada máquina cliente para aplicar los cambios:

bash
Copiar código
sudo systemctl restart chronyd
4. Verificación de sincronización
Después de realizar la configuración, es importante verificar que todas las máquinas estén sincronizadas correctamente con el servidor NTP.

Paso 1: Verifica las fuentes NTP en cada máquina
En cada máquina, ejecuta el siguiente comando para verificar las fuentes de tiempo configuradas:

bash
Copiar código
chronyc sources -v
Asegúrate de que la IP del servidor FreeIPA (10.17.3.11) aparezca como la fuente de tiempo principal.

Paso 2: Verifica el estado de la sincronización
Para verificar si la máquina está sincronizada correctamente con el servidor NTP, ejecuta el siguiente comando:

bash
Copiar código
chronyc tracking
Este comando te mostrará detalles sobre la sincronización de tiempo, incluida la desviación actual respecto a la fuente de tiempo.

5. Configuración manual de cliente NTP
Para configurar un cliente NTP manualmente y asegurarte de que esté sincronizado con el servidor FreeIPA, sigue estos pasos:

Paso 1: Configura el servidor NTP en /etc/chrony.conf
Abre el archivo de configuración chrony en el cliente:

bash
Copiar código
sudo nano /etc/chrony.conf
Añade la siguiente línea para usar FreeIPA como servidor NTP:

bash
Copiar código
server 10.17.3.11 iburst
Guarda los cambios y cierra el archivo.

Paso 2: Reinicia el servicio chronyd
Reinicia el servicio chronyd en la máquina cliente:

bash
Copiar código
sudo systemctl restart chronyd
Paso 3: Verifica la sincronización
Verifica que el cliente esté sincronizado correctamente:

Ejecuta:

bash
Copiar código
chronyc sources -v
Asegúrate de que el servidor FreeIPA (10.17.3.11) esté listado como la fuente NTP.

Luego, ejecuta:

bash
Copiar código
chronyc tracking
Este comando debe indicar que la máquina está correctamente sincronizada con FreeIPA.

6. Conclusión
Este documento detalla los pasos para configurar un servidor NTP utilizando FreeIPA como servidor central y cómo sincronizar las demás máquinas en la red para que utilicen este servidor como fuente de tiempo. Con chrony instalado y configurado en cada máquina, puedes asegurarte de que todas las máquinas de tu entorno estén sincronizadas con precisión.

Este documento debería cubrir todos los aspectos necesarios para configurar correctamente la sincronización de tiempo entre FreeIPA y las demás máquinas en tu red utilizando chrony.