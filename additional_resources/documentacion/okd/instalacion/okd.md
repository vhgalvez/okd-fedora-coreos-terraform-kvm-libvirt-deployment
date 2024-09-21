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


sudo curl --retry 5 --retry-delay 10 -L -o /tmp/openshift-install.tar.gz "https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-12-01-225814/openshift-install-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"

sudo mkdir -p /opt/bin
sudo tar -xzf /tmp/openshift-install.tar.gz -C /tmp
sudo mv /tmp/openshift-install /opt/bin/
sudo chmod +x /opt/bin/openshift-install
sudo rm -rf /tmp/openshift-install.tar.gz
openshift-install version



[core@helper ~]$ echo $PATH
/home/core/.local/bin:/home/core/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/local/bin
[core@helper ~]$ export PATH=$PATH:/opt/bin
[core@helper ~]$ ls -l /opt/bin/openshift-install
-rwxr-xr-x 1 root root 654617464 Nov 22  2023 /opt/bin/openshift-install
[core@helper ~]$ openshift-install version
openshift-install 4.14.0-0.okd-2023-12-01-225814
built from commit 82051a1c3d42e394be353bbe2eacf348ccb75970
release image quay.io/openshift/okd@sha256:4510c50834c07e71521a68c021320b5e44978245c8031a858f74328e54e89e1c
release architecture amd64



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