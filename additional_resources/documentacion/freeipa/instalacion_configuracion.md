Guía de Instalación y Configuración del Servidor DNS con FreeIPA en Rocky Linux
Introducción
Este documento proporciona una guía detallada para la instalación y configuración de FreeIPA como servidor DNS en Rocky Linux. FreeIPA es una solución integrada de identidad y autenticación que incluye características como Kerberos, LDAP, DNS y NTP.

Paso 1: Preparación del Sistema
1.1 Actualizar el Sistema
bash
Copiar código
sudo dnf update -y
1.2 Configurar el Nombre de Host
bash
Copiar código
sudo hostnamectl set-hostname freeipa1.cefaslocalserver.com
1.3 Editar el Archivo /etc/hosts
bash
Copiar código
echo "192.168.120.10 freeipa1.cefaslocalserver.com freeipa1" | sudo tee -a /etc/hosts
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

Paso 3: Configuración del Servidor DNS en FreeIPA
3.1 Configurar el DNS durante la Instalación de FreeIPA
Selecciona la opción de configurar el servidor DNS durante la instalación y proporciona la información requerida.

3.2 Verificación de la Configuración del DNS
bash
Copiar código
dig freeipa1.cefaslocalserver.com
Redes Virtuales y Configuración
Tabla de Configuración de Redes - br0 - Bridge Network
Red NAT	Nodos	Dirección IP	Rol del Nodo	Interfaz de Red
br0	bastion1	192.168.0.20	Acceso seguro, Punto de conexión de bridge	enp3s0f1
Tabla de Configuración de Redes - kube_network_02 - NAT Network
Red NAT	Nodos	Dirección IP	Rol del Nodo	Interfaz de Red
kube_network_02	freeipa1	10.17.3.11	Servidor de DNS y gestión de identidades	(Virtual - NAT)
kube_network_02	load_balancer1	10.17.3.12	Balanceo de carga para el clúster	(Virtual - NAT)
kube_network_02	postgresql1	10.17.3.13	Gestión de bases de datos	(Virtual - NAT)
Tabla de Configuración de Redes - kube_network_03 - NAT Network
Red NAT	Nodos	Dirección IP	Rol del Nodo	Interfaz de Red
kube_network_03	bootstrap1	10.17.4.20	Inicialización del clúster	(Virtual - NAT)
kube_network_03	master1	10.17.4.21	Gestión del clúster	(Virtual - NAT)
kube_network_03	master2	10.17.4.22	Gestión del clúster	(Virtual - NAT)
kube_network_03	master3	10.17.4.23	Gestión del clúster	(Virtual - NAT)
kube_network_03	worker1	10.17.4.24	Ejecución de aplicaciones	(Virtual - NAT)
kube_network_03	worker2	10.17.4.25	Ejecución de aplicaciones	(Virtual - NAT)
kube_network_03	worker3	10.17.4.26	Ejecución de aplicaciones	(Virtual - NAT)
Entrada para el servidor físico
Dirección IP	Hostname	Alias
192.168.0.21	physical1.cefaslocalserver.com	physical1
Resumen de los Hostnames e IPs
Dirección IP	Hostname
10.17.4.20	bootstrap1.serverlocalcefas.com
10.17.4.21	master1.serverlocalcefas.com
10.17.4.22	master2.serverlocalcefas.com
10.17.4.23	master3.serverlocalcefas.com
10.17.4.24	worker1.serverlocalcefas.com
10.17.4.25	worker2.serverlocalcefas.com
10.17.4.26	worker3.serverlocalcefas.com
192.168.0.20	bastion1.serverlocalcefas.com
10.17.3.11	freeipa1.serverlocalcefas.com
Recursos de Terraform para Redes
Red br0 - Bridge Network
hcl
Copiar código
resource "libvirt_network" "br0" {
  name      = var.rocky9_network_name
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
  addresses = ["192.168.0.0/24"]
}
Red kube_network_02 - NAT Network
hcl
Copiar código
resource "libvirt_network" "kube_network_02" {
  name      = "kube_network_02"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.3.0/24"]
}
Red kube_network_03 - NAT Network
hcl
Copiar código
resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}
Sigue estos pasos y configuraciones para instalar y configurar tu servidor DNS con FreeIPA en Rocky Linux y establecer la red virtual adecuada para tu infraestructura.

Nombre del Documento: Guía de Instalación y Configuración de Servidor DNS con FreeIPA en Rocky Linux
Este documento proporciona todos los detalles necesarios para configurar tu servidor FreeIPA con DNS en Rocky Linux, junto con la configuración de redes virtuales usando Terraform.






