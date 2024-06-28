Solución de Problemas de DNS con FreeIPA y Kerberos
Para solucionar el problema de las credenciales de Kerberos al intentar añadir registros DNS en FreeIPA, sigue estos pasos:

Paso 1: Obtener un Ticket de Kerberos
Primero, necesitas obtener un ticket de Kerberos con el usuario admin.

Ejecuta kinit para obtener un ticket:

bash
Copiar código
kinit admin
Introduce la contraseña del usuario admin cuando se te pida. Este comando debe completarse sin errores.

Paso 2: Añadir Registros DNS
Una vez que hayas obtenido el ticket de Kerberos, puedes añadir los registros DNS necesarios.

Añadir los registros DNS:

bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com physical1 --a-rec 192.168.0.21
ipa dnsrecord-add cefaslocalserver.com bootstrap1 --a-rec 10.17.4.20
ipa dnsrecord-add cefaslocalserver.com master1 --a-rec 10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master2 --a-rec 10.17.4.22
ipa dnsrecord-add cefaslocalserver.com master3 --a-rec 10.17.4.23
ipa dnsrecord-add cefaslocalserver.com worker1 --a-rec 10.17.4.24
ipa dnsrecord-add cefaslocalserver.com worker2 --a-rec 10.17.4.25
ipa dnsrecord-add cefaslocalserver.com worker3 --a-rec 10.17.4.26
ipa dnsrecord-add cefaslocalserver.com bastion1 --a-rec 192.168.0.20
ipa dnsrecord-add cefaslocalserver.com freeipa1 --a-rec 10.17.3.11
ipa dnsrecord-add cefaslocalserver.com load_balancer1 --a-rec 10.17.3.12
ipa dnsrecord-add cefaslocalserver.com postgresql1 --a-rec 10.17.3.13
Verificación de Credenciales de Kerberos
Si sigues recibiendo el error "did not receive Kerberos credentials", puede que necesites asegurarte de que tu ticket de Kerberos esté vigente y que el tiempo de vida del ticket no haya expirado.

Verificar el ticket de Kerberos:

bash
Copiar código
klist
Este comando muestra el ticket actual y su tiempo de vida. Asegúrate de que el ticket no haya expirado.

Eliminar el ticket de Kerberos si es necesario y obtener uno nuevo:

bash
Copiar código
kdestroy
kinit admin
Reintento de Comandos
Después de asegurarte de que tienes un ticket válido, reintenta añadir los registros DNS:

bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com physical1 --a-rec 192.168.0.21
Repite con los demás registros necesarios.

Resumen de Comandos
Aquí tienes un resumen de todos los comandos importantes para asegurar que los registros DNS se añadan y verifiquen correctamente:

Obtener un ticket de Kerberos:

bash
Copiar código
kinit admin
Añadir los registros DNS:

bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com physical1 --a-rec 192.168.0.21
ipa dnsrecord-add cefaslocalserver.com bootstrap1 --a-rec 10.17.4.20
ipa dnsrecord-add cefaslocalserver.com master1 --a-rec 10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master2 --a-rec 10.17.4.22
ipa dnsrecord-add cefaslocalserver.com master3 --a-rec 10.17.4.23
ipa dnsrecord-add cefaslocalserver.com worker1 --a-rec 10.17.4.24
ipa dnsrecord-add cefaslocalserver.com worker2 --a-rec 10.17.4.25
ipa dnsrecord-add cefaslocalserver.com worker3 --a-rec 10.17.4.26
ipa dnsrecord-add cefaslocalserver.com bastion1 --a-rec 192.168.0.20
ipa dnsrecord-add cefaslocalserver.com freeipa1 --a-rec 10.17.3.11
ipa dnsrecord-add cefaslocalserver.com load_balancer1 --a-rec 10.17.3.12
ipa dnsrecord-add cefaslocalserver.com postgresql1 --a-rec 10.17.3.13
Verificar los registros DNS:

bash
Copiar código
ipa dnsrecord-find cefaslocalserver.com
Verificar la resolución DNS desde una VM:

bash
Copiar código
dig physical1.cefaslocalserver.com
dig freeipa1.cefaslocalserver.com
dig google.com
Verificación de la Resolución DNS en las Máquinas Virtuales
Verificar la configuración DNS en las VMs:
Asegúrate de que /etc/resolv.conf en cada VM apunte al servidor FreeIPA (10.17.3.11) como servidor DNS.

bash
Copiar código
cat /etc/resolv.conf
Deberías ver una salida similar a esta:

Copiar código
nameserver 10.17.3.11
nameserver 8.8.8.8
Probar la resolución DNS en las VMs:

bash
Copiar código
dig physical1.cefaslocalserver.com
dig bootstrap1.cefaslocalserver.com
dig master1.cefaslocalserver.com
dig google.com
Y también prueba con ping:

bash
Copiar código
ping -c 4 physical1.cefaslocalserver.com
ping -c 4 bootstrap1.cefaslocalserver.com
ping -c 4 master1.cefaslocalserver.com
ping -c 4 google.com
Si la Resolución DNS Falla
Revisar la configuración del servidor DNS FreeIPA:
Asegúrate de que el servicio DNS en el servidor FreeIPA esté activo y funcionando correctamente.

bash
Copiar código
sudo systemctl status named
Verificar la configuración del firewall en el servidor FreeIPA:
Asegúrate de que el firewall permite el tráfico DNS en los puertos 53 TCP/UDP.

bash
Copiar código
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-port=53/udp
sudo firewall-cmd --permanent --add-port=53/tcp
sudo firewall-cmd --reload
Limpiar la caché DNS en las VMs:

bash
Copiar código
sudo systemd-resolve --flush-caches
sudo systemctl restart systemd-resolved
Verificar la conectividad hacia el servidor FreeIPA:

bash
Copiar código
ping -c 4 10.17.3.11
Comprobación Final
Después de seguir estos pasos, deberías poder resolver tanto nombres de dominio internos como externos utilizando tu servidor DNS de FreeIPA.