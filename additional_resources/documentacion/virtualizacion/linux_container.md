# Documento Técnico de Preparación del Ambiente para el Proyecto

Este documento detalla los pasos necesarios para preparar el ambiente y configurar el sistema para desplegar máquinas virtuales usando Terraform y Libvirt. A continuación, se explican paso a paso las tareas requeridas.

## Paso 1: Instalación de Dependencias

### Instalación de QEMU, KVM y Libvirt
Ejecuta los siguientes comandos para instalar las herramientas necesarias:

```bash
sudo dnf install -y qemu-kvm qemu-img libvirt libvirt-client virt-install
sudo systemctl enable --now libvirtd
```


## Paso 2: Configuración del Pool de Almacenamiento
Creación Manual del Pool default
Primero, definimos, construimos, iniciamos y configuramos el pool default para que se inicie automáticamente con el sistema:

bash
Copiar código
sudo virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
sudo virsh pool-build default
sudo virsh pool-start default
sudo virsh pool-autostart default
Verificación de la Creación del Pool
Verifica que el pool se haya creado y esté activo:

bash
Copiar código
sudo virsh pool-list --all
Paso 3: Descarga de Imágenes
Descarga de la Imagen de Flatcar Linux y Verificación
Crear el directorio y descargar la imagen:

bash
Copiar código
mkdir -p /var/lib/libvirt/images/flatcar-linux
cd /var/lib/libvirt/images/flatcar-linux
wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_image.img{,.sig}
Verificar la firma de la imagen:

bash
Copiar código
gpg --verify flatcar_production_qemu_image.img.sig
Nota: Si obtienes un error de clave pública, importa la clave pública de Flatcar:

bash
Copiar código
gpg --keyserver keyserver.ubuntu.com --recv-keys 85F7C8868837E271
gpg --verify flatcar_production_qemu_image.img.sig
Creación de la Imagen QCOW2 para Flatcar Linux
Crear la imagen snapshot:

bash
Copiar código
qemu-img create -f qcow2 -F qcow2 -b /var/lib/libvirt/images/flatcar-linux/flatcar_production_qemu_image.img /var/lib/libvirt/images/flatcar-linux/flatcar-linux1.qcow2
Descarga de la Imagen de Rocky Linux 9
Descargar la imagen de Rocky Linux 9 Generic Cloud en formato QCOW2:

bash
Copiar código
cd /var/lib/libvirt/images
wget https://download.rockylinux.org/pub/rocky/9/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
