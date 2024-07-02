# Guía de Instalación y Configuración del Servidor DNS con FreeIPA en Rocky Linux

## Introducción
Este documento proporciona una guía detallada para la instalación y configuración de FreeIPA como servidor DNS en Rocky Linux. FreeIPA es una solución integrada de identidad y autenticación que incluye características como Kerberos, LDAP, DNS y NTP.

## Paso 1: Preparación del Sistema

### 1.1 Actualizar el Sistema

```bash
sudo dnf update -y
```

### 1.2 Verificar el Nombre de Host

```bash
cat /etc/hostname
```


### 1.3 Verificar el Archivo /etc/hosts

```bash
cat /etc/hosts
```

## Paso 2: Instalación de FreeIPA

### 2.1 Instalar FreeIPA y el Servidor DNS
sudo dnf install -y ipa-server ipa-server-dns

### 2.2 Ejecutar el Script de Instalación de FreeIPA

```bash
sudo ipa-server-install
```

Durante la instalación, sigue las instrucciones en pantalla y proporciona los parámetros necesarios como el dominio, el realm y la contraseña de administración.




```bash
[core@freeipa1 ~]$ sudo ipa-server-install

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

Do you want to configure integrated DNS (BIND)? [no]: yes

Enter the fully qualified domain name of the computer
on which you're setting up server software. Using the form
<hostname>.<domainname>
Example: master.example.com


Server host name [freeipa1.cefaslocalserver.com]: freeipa1.cefaslocalserver.com

Warning: skipping DNS resolution of host freeipa1.cefaslocalserver.com
The domain name has been determined based on the host name.

Please confirm the domain name [cefaslocalserver.com]: cefaslocalserver.com

The kerberos protocol requires a Realm name to be defined.
This is typically the domain name converted to uppercase.

Please provide a realm name [CEFASLOCALSERVER.COM]: CEFASLOCALSERVER.COM
Certain directory server operations require an administrative user.
This user is referred to as the Directory Manager and has full access
to the Directory for system management tasks and will be added to the
instance of directory server created for IPA.
The password must be at least 8 characters long.

Directory Manager password:
Password (confirm):

The IPA server requires an administrative user, named 'admin'.
This user is a regular system account used for IPA server administration.

IPA admin password:
Password (confirm):

Checking DNS domain cefaslocalserver.com., please wait ...
Do you want to configure DNS forwarders? [yes]: no
No DNS forwarders configured
Do you want to search for missing reverse zones? [yes]: yes
Checking DNS domain 3.17.10.in-addr.arpa., please wait ...
Reverse zone 3.17.10.in-addr.arpa. for IP address 10.17.3.11 already exists
Trust is configured but no NetBIOS domain name found, setting it now.
Enter the NetBIOS name for the IPA domain.
Only up to 15 uppercase ASCII letters, digits and dashes are allowed.
Example: EXAMPLE.


NetBIOS domain name [CEFASLOCALSERVE]: CEFASLOCALSERVE
ç
Do you want to configure chrony with NTP server or pool address? [no]: no

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

The following operations may take some minutes to complete.
```

## Paso 3: Configuración del Servidor DNS en FreeIPA

### 3.1 Configurar el DNS durante la Instalación de FreeIPA

Selecciona la opción de configurar el servidor DNS durante la instalación y proporciona la información requerida.


3.2 Verificación de la Configuración del DNS

```bash
dig freeipa1.cefaslocalserver.com
```
## Paso 4 Configuración de Reenvío de DNS en FreeIPA

### Configurar los reenviadores DNS en FreeIPA:

```bash
[core@freeipa1 ~]$ kinit admin
Password for admin@CEFASLOCALSERVER.COM:
```
12345678

Asegúrate de que FreeIPA esté configurado para reenviar solicitudes DNS que no pueda resolver internamente a un servidor DNS externo, como el de Google (8.8.8.8). Si no lo configuraste durante la instalación, puedes hacerlo manualmente.

```bash
ipa dnsconfig-mod --forwarder=8.8.8.8
```

# Redes Virtuales y Configuración

## Tabla de Configuración de Redes - br0 - Bridge Network

| Red NAT | Nodos    | Dirección IP | Rol del Nodo                            | Interfaz de Red |
|---------|----------|--------------|-----------------------------------------|-----------------|
| br0     | bastion1 | 192.168.0.20 | Acceso seguro, Punto de conexión de bridge | enp3s0f1        |

## Tabla de Configuración de Redes - kube_network_02 - NAT Network

| Red NAT        | Nodos          | Dirección IP | Rol del Nodo                     | Interfaz de Red |
|----------------|----------------|--------------|----------------------------------|-----------------|
| kube_network_02 | freeipa1       | 10.17.3.11   | Servidor de DNS y gestión de identidades | (Virtual - NAT) |
| kube_network_02 | load_balancer1 | 10.17.3.12   | Balanceo de carga para el clúster | (Virtual - NAT) |
| kube_network_02 | postgresql1    | 10.17.3.13   | Gestión de bases de datos         | (Virtual - NAT) |

## Tabla de Configuración de Redes - kube_network_03 - NAT Network

| Red NAT        | Nodos          | Dirección IP | Rol del Nodo              | Interfaz de Red |
|----------------|----------------|--------------|---------------------------|-----------------|
| kube_network_03 | bootstrap1     | 10.17.4.20   | Inicialización del clúster | (Virtual - NAT) |
| kube_network_03 | master1        | 10.17.4.21   | Gestión del clúster        | (Virtual - NAT) |
| kube_network_03 | master2        | 10.17.4.22   | Gestión del clúster        | (Virtual - NAT) |
| kube_network_03 | master3        | 10.17.4.23   | Gestión del clúster        | (Virtual - NAT) |
| kube_network_03 | worker1        | 10.17.4.24   | Ejecución de aplicaciones  | (Virtual - NAT) |
| kube_network_03 | worker2        | 10.17.4.25   | Ejecución de aplicaciones  | (Virtual - NAT) |
| kube_network_03 | worker3        | 10.17.4.26   | Ejecución de aplicaciones  | (Virtual - NAT) |

## Entrada para el servidor físico

| Dirección IP  | Hostname                        | Alias     |
|---------------|---------------------------------|-----------|
| 192.168.0.21  | physical1.cefaslocalserver.com  | physical1 |

## Resumen de los Hostnames e IPs

| Dirección IP  | Hostname                         |
|---------------|----------------------------------|
| 10.17.4.20    | bootstrap1.cefaslocalserver.com  |
| 10.17.4.21    | master1.cefaslocalserver.com     |
| 10.17.4.22    | master2.cefaslocalserver.com     |
| 10.17.4.23    | master3.cefaslocalserver.com     |
| 10.17.4.24    | worker1.cefaslocalserver.com     |
| 10.17.4.25    | worker2.cefaslocalserver.com     |
| 10.17.4.26    | worker3.cefaslocalserver.com     |
| 192.168.0.20  | bastion1.cefaslocalserver.com    |
| 10.17.3.11    | freeipa1.cefaslocalserver.com    |
| 10.17.3.12    | load_balancer1.cefaslocalserver.com |
| 10.17.3.13    | postgresql1.cefaslocalserver.com |

## Recursos de Terraform para Redes

### Red br0 - Bridge Network

```hcl
resource "libvirt_network" "br0" {
  name      = var.rocky9_network_name
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
  addresses = ["192.168.0.0/24"]
}
```


### Red kube_network_02 - NAT Network

```hcl
resource "libvirt_network" "kube_network_02" {
  name      = "kube_network_02"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.3.0/24"]
}
```

### Red kube_network_03 - NAT Network

```hcl
resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}
```


Directory Manager password:
Password (confirm):
12345678

kinit admin
12345678
