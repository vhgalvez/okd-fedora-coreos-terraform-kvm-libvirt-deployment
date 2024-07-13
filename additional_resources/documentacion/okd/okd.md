


Guía de Instalación de OKD (OpenShift Kubernetes Distribution) en un Entorno con Terraform y KVM
Este documento proporciona una guía detallada para la instalación de OKD en un entorno configurado con Terraform y KVM. Asegúrate de seguir cada paso cuidadosamente para garantizar una instalación exitosa.

Requisitos Previos
Servidor con KVM y libvirt instalados.
Rocky Linux 9.3 o similar.
Terraform v0.13 o superior.
Acceso a un servidor DNS (FreeIPA) configurado.
Llave SSH configurada.
Paso 1: Configuración de la Infraestructura con Terraform
1.1 Preparar los Directorios de Terraform
Navega al directorio donde están ubicados tus archivos de configuración de Terraform.

Clonar el Repositorio de Terraform
bash
Copiar código
sudo git clone https://github.com/vhgalvez/terraform-openshift-kvm-deployment_linux_Flatcar.git

bash
Copiar código
cd terraform-openshift-kvm-deployment_linux_Flatcar
1.2 Aplicar Configuración para br0_network
bash
Copiar código
cd br0_network
sudo terraform init --upgrade
sudo terraform apply
1.3 Aplicar Configuración para nat_network_02
bash
Copiar código
cd ../nat_network_02
sudo terraform init --upgrade
sudo terraform apply
1.4 Aplicar Configuración para nat_network_03
bash
Copiar código
cd ../nat_network_03
sudo terraform init --upgrade
sudo terraform apply
Paso 2: Configuración del DNS en FreeIPA
2.1 Añadir Entradas DNS
Ejecuta los siguientes comandos para añadir las entradas DNS necesarias:

bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com api.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com api-int.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master1.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master2.produccion --a-rec=10.17.4.22
ipa dnsrecord-add cefaslocalserver.com master3.produccion --a-rec=10.17.4.23
ipa dnsrecord-add cefaslocalserver.com worker1.produccion --a-rec=10.17.4.24
ipa dnsrecord-add cefaslocalserver.com worker2.produccion --a-rec=10.17.4.25
ipa dnsrecord-add cefaslocalserver.com worker3.produccion --a-rec=10.17.4.26
Paso 3: Descargar la Última Versión Estable de OKD
3.1 Acceder al Nodo Bootstrap
bash
Copiar código
sudo ssh -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift core@10.17.3.14 -p 22
3.2 Descargar la Última Versión Estable de OKD
Visita la página de OKD Releases para encontrar la última versión estable.

bash
Copiar código
curl -LO https://github.com/openshift/okd/releases/download/<version>/openshift-install-linux.tar.gz
tar -xzvf openshift-install-linux.tar.gz
sudo mv openshift-install /usr/local/bin/
Asegúrate de reemplazar <version> con la versión específica que deseas instalar.

Paso 4: Configurar install-config.yaml
Crea el archivo install-config.yaml con el siguiente contenido:

yaml
Copiar código
apiVersion: v1
baseDomain: cefaslocalserver.com
metadata:
  name: produccion
compute:
- name: worker
  replicas: 3
controlPlane:
- name: master
  replicas: 3
platform:
  none: {}
networking:
  networkType: OpenShiftSDN
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  serviceNetwork:
  - 172.30.0.0/16
pullSecret: '{"auths": ...}'  # Reemplaza con tu pull secret
sshKey: 'ssh-rsa AAAA...'  # Reemplaza con tu clave SSH pública
Paso 5: Generar Manifiestos y Personalizar
5.1 Generar los Manifiestos
bash
Copiar código
openshift-install create manifests --dir=/home/core/okd-install
5.2 Personalizar los Manifiestos
Personaliza los manifiestos generados en el directorio /home/core/okd-install/manifests si es necesario.

Paso 6: Crear el Clúster
Inicia la creación del clúster:

bash
Copiar código
openshift-install create cluster --dir=/home/core/okd-install --log-level=debug
Paso 7: Verificar la Instalación
7.1 Verificar el Estado de los Nodos
bash
Copiar código
kubectl get nodes
7.2 Aprobar Solicitudes de Certificado (CSR)
bash
Copiar código
kubectl get csr
kubectl certificate approve <CSR_NAME>
Paso 8: Esperar la Compleción de la Instalación
Sigue los logs y espera a que la instalación se complete:

bash
Copiar código
openshift-install --dir=/home/core/okd-install wait-for install-complete --log-level=debug
Paso 9: Post-Instalación
9.1 Configurar Acceso a la Consola Web y API
Asegúrate de que api.produccion.cefaslocalserver.com y console-openshift-console.apps.produccion.cefaslocalserver.com sean accesibles.

9.2 Monitorear y Asegurar tu Clúster
Prometheus para monitoreo.
Grafana para visualización.
ELK Stack para gestión de logs.
Nagios para monitoreo adicional.
Paso 10: Configurar Aplicaciones y Servicios
Despliega microservicios y aplicaciones en el clúster utilizando herramientas como Helm.

Paso 11: Documentación y Mantenimiento
Documenta todas las configuraciones y procesos, y realiza mantenimientos periódicos y actualizaciones.

Recursos de Terraform para Redes
Definición de Redes en Terraform
hcl
Copiar código
# Red br0 - Bridge Network
resource "libvirt_network" "br0" {
  name      = var.rocky9_network_name
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
  addresses = ["192.168.0.0/24"]
}

# Red kube_network_02 - NAT Network
resource "libvirt_network" "kube_network_02" {
  name      = "kube_network_02"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.3.0/24"]
}

# Red kube_network_03 - NAT Network
resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}

Contacto
Para cualquier duda o problema, por favor abre un issue en el repositorio o contacta al mantenedor del proyecto.

Mantenedor del Proyecto: Victor Galvez

Siguiendo estos pasos, deberías poder instalar y configurar un clúster OKD en tu entorno utilizando Terraform y KVM. Si tienes alguna duda o problema, no dudes en contactar al mantenedor del proyecto o abrir un issue en el repositorio.