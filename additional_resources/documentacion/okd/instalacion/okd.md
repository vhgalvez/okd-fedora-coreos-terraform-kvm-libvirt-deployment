Para implementar la imagen Fedora CoreOS en tu proyecto con Terraform y libvirt, sigue estos pasos:

Descarga la imagen Fedora CoreOS:

Descarga la imagen de Fedora CoreOS, preferentemente en formato QCOW2:

bash
Copiar código
curl -O https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240825.3.0/x86_64/fedora-coreos-40.20240825.3.0-qemu.x86_64.qcow2.xz
Descomprime la imagen:

Si la imagen descargada está comprimida, descomprímela:

bash
Copiar código
xz -d fedora-coreos-40.20240825.3.0-qemu.x86_64.qcow2.xz
Ubica la imagen en tu directorio de almacenamiento:

Mueve la imagen descomprimida al directorio de almacenamiento definido en tu configuración:

bash
Copiar código
mv fedora-coreos-40.20240825.3.0-qemu.x86_64.qcow2 /mnt/lv_data/organized_storage/images/
Define la imagen en tu archivo terraform.tfvars:

Actualiza tu archivo terraform.tfvars para especificar la ruta de la imagen descargada:

hcl
Copiar código
base_image = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240825.3.0-qemu.x86_64.qcow2"
Configura Terraform para usar la imagen:

En tu archivo main.tf, asegúrate de que el bloque del recurso libvirt_volume esté configurado correctamente para utilizar la imagen base:

hcl
Copiar código
resource "libvirt_volume" "base" {
  name   = "fedora-coreos-base"
  source = var.base_image
  pool   = libvirt_pool.okd_storage_pool.name
  format = "qcow2"
}
Aplica la configuración de Terraform:

Finalmente, aplica la configuración de Terraform para crear las máquinas virtuales con la imagen de Fedora CoreOS:

bash
Copiar código
terraform init
terraform apply
Con estos pasos, estarás implementando correctamente la imagen de Fedora CoreOS en tu proyecto OKD con Terraform y KVM.



openshift-install create ignition-configs --dir=./ignition






# Descargar e instalar OpenShift Installer (OKD v4.14.0)



sudo mkdir -p /usr/local/bin/

sudo curl --retry 5 --retry-delay 10 -L -o /tmp/openshift-install.tar.gz "https://github.com/openshift/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-install-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz"


sudo tar -xzf /tmp/openshift-install.tar.gz -C /tmp
sudo mv /tmp/openshift-install /usr/local/bin/openshift-install
sudo chmod +x /usr/local/bin/openshift-install
sudo rm -rf /tmp/openshift-install.tar.gz
openshift-install version


/usr/local/bin/openshift-install



sudo mkdir -p /opt/bin


openshift-install create ignition-configs --dir=

openshift-install create ignition-configs --dir=/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install --log-level=debug


sudo OPENSHIFT_INSTALL_PLATFORM=none /usr/local/bin/openshift-install create ignition-configs --dir=./ignition --log-level=debug


Instalación en Rocky Linux:
Crea el directorio para binarios:

bash
Copiar código
sudo mkdir -p /usr/local/bin
Descargar el instalador de OpenShift (OKD):

bash
Copiar código
sudo curl --retry 5 --retry-delay 10 -L -o /tmp/openshift-install.tar.gz "https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-12-01-225814/openshift-install-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"
Extraer el archivo:

bash
Copiar código
sudo tar -xzf /tmp/openshift-install.tar.gz -C /tmp
Mover el binario a /usr/local/bin/:

bash
Copiar código
sudo mv /tmp/openshift-install /usr/local/bin/
sudo chmod +x /usr/local/bin/openshift-install
Verificar que esté en el PATH: Ejecuta:

bash
Copiar código
echo $PATH
Si /usr/local/bin no está en el PATH, añade la siguiente línea a tu archivo ~/.bashrc:

bash
Copiar código
export PATH=$PATH:/usr/local/bin
Luego, recarga el archivo:

bash
Copiar código
source ~/.bashrc
Ejecutar el comando:

bash
Copiar código
openshift-install create ignition-configs --dir=./ignition
Estos pasos deberían funcionar correctamente para instalar openshift-install en Rocky Linux y generar los archivos de configuración Ignition.



o install yamllint on Rocky Linux, follow these steps:

Ensure EPEL Repository is enabled (if it's not already):

bash
Copiar código
sudo dnf install epel-release
Install yamllint:

bash
Copiar código
sudo dnf install yamllint
Once installed, you can verify the installation by running:

bash
Copiar código
yamllint --version



openshift-install create manifests --dir=/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install --log-level=debug


openshift-install create ignition-configs --dir=/home/core/okd-install/ignition




openshift-install create manifests --dir=/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install --log-level=debug



openshift-install create ignition-configs --dir=/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install --log-level=debug

sudo chown -R core:core /home/core/okd-install
sudo chmod -R 755 /home/core/okd-install

sudo chown -R victory:victory /home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install
sudo chmod -R 755 /home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install



Intenta lo siguiente:

bash
Copiar código
echo $OPENSHIFT_INSTALL_PLATFORM
Este comando mostrará el valor de la variable de entorno OPENSHIFT_INSTALL_PLATFORM. Si no tiene valor asignado, no mostrará nada.

Si necesitas exportar o asignar un valor a esta variable, puedes hacerlo de esta manera:

bash
Copiar código
export OPENSHIFT_INSTALL_PLATFORM=baremetal
Luego, puedes verificar el valor:

bash
Copiar código
echo $OPENSHIFT_INSTALL_PLATFORM




 # Instalar oc (OpenShift Client)
sudo mkdir -p /usr/local/bin/
sudo curl -L -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
sudo tar -xzf /tmp/oc.tar.gz -C /tmp
sudo mv /tmp/oc /usr/local/bin/
sudo chmod +x /usr/local/bin/
sudo rm -rf /tmp/oc.tar.gz




Fromato JSON

RFC 8259 

https://jsonformatter.curiousconcept.com/

https://www.base64decode.org/








sudo chown -R victory:victory /home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install
sudo chmod -R 755 /home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install



sudo chmod -R 755 
sudo chown -R core:core



sudo mkdir -p /usr/local/bin/

sudo curl --retry 5 --retry-delay 10 -L -o /tmp/openshift-install.tar.gz "https://github.com/openshift/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-install-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz"


sudo tar -xzf /tmp/openshift-install.tar.gz -C /tmp
sudo mv /tmp/openshift-install /usr/local/bin/
sudo chmod +x /usr/local/bin/openshift-install
sudo rm -rf /tmp/openshift-install.tar.gz
openshift-install version


1. Download the Fedora CoreOS Image and Verification Files
bash
Copiar código
# Download the Fedora CoreOS image
curl -O https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240906.3.0/x86_64/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz

# Download the checksum file and the signature file
curl -O https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240906.3.0/x86_64/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz-CHECKSUM
curl -O https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240906.3.0/x86_64/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz.sig
2. Download the Fedora GPG Key
bash
Copiar código
# Download the Fedora GPG key for verification
curl -O https://fedoraproject.org/fedora.gpg
3. Verify the Signature of the Downloaded Image
Use gpgv to verify the image file with the GPG key.

bash
Copiar código
# Verify the signature against the downloaded GPG key
gpgv --keyring ./fedora.gpg fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz.sig fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz
If the output indicates that the signature is valid, the file integrity is confirmed.

4. Verify the SHA256 Checksum
Finally, use sha256sum to ensure the file's integrity by comparing it against the checksum.

bash
Copiar código
# Verify the checksum matches
sha256sum -c fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz-CHECKSUM
If the checksum matches, you will see output like:

makefile
Copiar código
fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz: OK
This confirms that your downloaded image is valid and ready to use.



Actualización de la Imagen Base de Fedora CoreOS para Terraform
Esta guía explica los pasos para actualizar la imagen de Fedora CoreOS que se utiliza con Terraform para un despliegue de OpenShift/Kubernetes. Siga los pasos a continuación para descargar la última imagen, descomprimirla y actualizar la configuración de Terraform para usarla.

Pasos
1. Descargar la Nueva Imagen de Fedora CoreOS
Ejecute el siguiente comando curl para descargar la última imagen de Fedora CoreOS con lógica de reintentos para manejar posibles problemas de red:

bash
Copiar código
sudo curl --retry 5 --retry-delay 10 -L -o /tmp/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240906.3.0/x86_64/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz
--retry 5: Reintenta la descarga hasta 5 veces en caso de fallo.
--retry-delay 10: Espera 10 segundos entre reintentos.
-L: Sigue redireccionamientos si la URL cambia.
-o /tmp/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz: Especifica la ruta de salida del archivo.
2. Descomprimir la Imagen
El archivo descargado está en formato .xz, por lo que necesita descomprimirlo para obtener la imagen .qcow2:

bash
Copiar código
sudo xz -d /tmp/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2.xz
Este comando extrae la imagen .qcow2 del archivo comprimido .xz.

3. Mover la Imagen a la Ubicación de Almacenamiento
Después de descomprimir la imagen, muévala a la ubicación de almacenamiento deseada donde su configuración de Terraform la espera:

bash
Copiar código
sudo mv /tmp/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2 /mnt/lv_data/organized_storage/images/
En este caso, la imagen se moverá a /mnt/lv_data/organized_storage/images/.

4. Actualizar la Configuración de Terraform (terraform.tfvars)
Necesita actualizar la variable base_image en su archivo terraform.tfvars para que apunte a la nueva imagen:

hcl
Copiar código
base_image = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"
Asegúrese de que la ruta coincida con la ubicación donde movió el archivo .qcow2.
Verifique que el nombre del archivo y la ruta sean correctos para evitar errores durante la ejecución de Terraform.
5. Aplicar los Cambios con Terraform
Después de actualizar el archivo terraform.tfvars, puede ejecutar nuevamente los comandos de Terraform para aplicar los cambios con la nueva imagen base:

bash
Copiar código
terraform init
terraform plan
terraform apply
terraform init: Re-inicializa el directorio de trabajo de Terraform.
terraform plan: Muestra el plan de ejecución para previsualizar los cambios.
terraform apply: Aplica los cambios para actualizar la infraestructura con la nueva imagen de Fedora CoreOS.
Siguiendo estos pasos, se asegurará de que su configuración de Terraform utilice la última imagen de Fedora CoreOS.