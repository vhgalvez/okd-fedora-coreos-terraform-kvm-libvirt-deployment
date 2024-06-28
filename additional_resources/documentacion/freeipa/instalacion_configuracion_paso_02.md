Guía Paso a Paso para la Instalación y Configuración de FreeIPA con DNS en Rocky Linux
Introducción
Este documento proporciona una guía detallada para la instalación y configuración de FreeIPA como servidor DNS en Rocky Linux. FreeIPA es una solución integrada de identidad y autenticación que incluye características como Kerberos, LDAP, DNS y NTP.

Paso a Paso de la Instalación
Paso 1: Preparación del Sistema
1.1 Actualizar el Sistema
bash
Copiar código
sudo dnf update -y
1.2 Verificar el Nombre de Host
bash
Copiar código
cat /etc/hostname
1.3 Verificar el Archivo /etc/hosts
bash
Copiar código
cat /etc/hosts
Paso 2: Instalación de FreeIPA
2.1 Instalar FreeIPA y el Servidor DNS
bash
Copiar código
sudo dnf install -y ipa-server ipa-server-dns
2.2 Ejecutar el Script de Instalación de FreeIPA
bash
Copiar código
sudo ipa-server-install
Durante la instalación, sigue las instrucciones en pantalla y proporciona los parámetros necesarios como el dominio, el realm y la contraseña de administración.

Detalles del Proceso de Instalación
plaintext
Copiar código
The log file for this installation can be found in /var/log/ipaserver-install.log
==============================================================================
This program will set up the IPA Server.
Version 4.11.0

This includes:
  * Configure a stand-alone CA (dogtag) for certificate management
  * Configure the NTP client (chronyd)
  * Create and configure an instance of Directory Server
  * Create and configure a Kerberos Key Distribution Center (KDC)
  * Configure Apache (httpd)
  * Configure SID generation
  * Configure the KDC to enable PKINIT

To accept the default shown in brackets, press the Enter key.
Configurar DNS Integrado
plaintext
Copiar código
Do you want to configure integrated DNS (BIND)? [no]: yes
Proporcionar el Nombre del Servidor
plaintext
Copiar código
Enter the fully qualified domain name of the computer
on which you're setting up server software. Using the form
<hostname>.<domainname>
Example: master.example.com

Server host name [freeipa1.cefaslocalserver.com]: freeipa1.cefaslocalserver.com
Confirmar el Nombre del Dominio
plaintext
Copiar código
Please confirm the domain name [cefaslocalserver.com]: cefaslocalserver.com
Proporcionar el Nombre del Realm
plaintext
Copiar código
The kerberos protocol requires a Realm name to be defined.
This is typically the domain name converted to uppercase.

Please provide a realm name [CEFASLOCALSERVER.COM]: CEFASLOCALSERVER.COM
Proporcionar Contraseña del Administrador del Directorio
plaintext
Copiar código
Certain directory server operations require an administrative user.
This user is referred to as the Directory Manager and has full access
to the Directory for system management tasks and will be added to the
instance of directory server created for IPA.
The password must be at least 8 characters long.

Directory Manager password:
Password (confirm):
Proporcionar Contraseña del Administrador IPA
plaintext
Copiar código
The IPA server requires an administrative user, named 'admin'.
This user is a regular system account used for IPA server administration.

IPA admin password:
Password (confirm):
Configurar Reenviadores DNS
plaintext
Copiar código
Checking DNS domain cefaslocalserver.com., please wait ...
Do you want to configure DNS forwarders? [yes]: no
No DNS forwarders configured
Configurar Zonas Inversas
plaintext
Copiar código
Do you want to search for missing reverse zones? [yes]: yes
Checking DNS domain 3.17.10.in-addr.arpa., please wait ...
Reverse zone 3.17.10.in-addr.arpa. for IP address 10.17.3.11 already exists
Configurar el Nombre del Dominio NetBIOS
plaintext
Copiar código
Trust is configured but no NetBIOS domain name found, setting it now.
Enter the NetBIOS name for the IPA domain.
Only up to 15 uppercase ASCII letters, digits and dashes are allowed.
Example: EXAMPLE.

NetBIOS domain name [CEFASLOCALSERVE]: CEFASLOCALSERVE
Configurar Chrony (NTP)
plaintext
Copiar código
Do you want to configure chrony with NTP server or pool address? [no]: no
Confirmar Configuración Final
plaintext
Copiar código
The IPA Master Server will be configured with:
Hostname:       freeipa1.cefaslocalserver.com
IP address(es): 10.17.3.11
Domain name:    cefaslocalserver.com
Realm name:     CEFASLOCALSERVER.COM

The CA will be configured with:
Subject DN:   CN=Certificate Authority,O=CEFASLOCALSERVER.COM
Subject base: O=CEFASLOCALSERVER.COM
Chaining:     self-signed

BIND DNS server will be configured to serve IPA domain with:
Forwarders:       No forwarders
Forward policy:   only
Reverse zone(s):  No reverse zone

Continue to configure the system with these values? [no]: yes
Paso 3: Verificación y Configuración Adicional
Verificar los Servicios de FreeIPA
bash
Copiar código
sudo systemctl status ipa
sudo systemctl status named
Configurar Reenviadores DNS si es Necesario
bash
Copiar código
ipa dnsconfig-mod --forwarder=8.8.8.8
Si encuentras el error ipa: ERROR: did not receive Kerberos credentials, debes obtener un ticket de Kerberos antes de ejecutar el comando:

bash
Copiar código
kinit admin
ipa dnsconfig-mod --forwarder=8.8.8.8
Verificar la Configuración DNS
bash
Copiar código
dig freeipa1.cefaslocalserver.com
dig google.com
Resumen
Este documento proporciona un procedimiento paso a paso para instalar y configurar FreeIPA como servidor DNS en Rocky Linux. Los pasos incluyen la preparación del sistema, instalación y configuración de FreeIPA, y verificación de los servicios y configuraciones DNS. Al seguir esta guía, podrás asegurar que tu servidor FreeIPA esté correctamente configurado y operativo.

Asegúrate de que los puertos de red necesarios estén abiertos y realiza copias de seguridad de los certificados CA. Con esta configuración, podrás gestionar identidades y autenticaciones de manera eficiente en tu red.