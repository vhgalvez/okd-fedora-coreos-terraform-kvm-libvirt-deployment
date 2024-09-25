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

















cat >> pull_secret.json <<EOF
{
    "auths":{
        "cloud.openshift.com":{
            "auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfZTk5M2RiN2MwMDNkNDFlNDhmZGU4ZGE0OWIxZmZkYTI6WkhMMk5HUVFTS01aS1JJSTBPME5aUzFaSVgwQU9GTTNDQjdQUkxMMjc5UzRZN1BKSTBURVdSQUhLSFFZVVJOUw==",
            "email":"vhgalvez@gmail.com"
        },
        "quay.io":{
            "auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfZTk5M2RiN2MwMDNkNDFlNDhmZGU4ZGE0OWIxZmZkYTI6WkhMMk5HUVFTS01aS1JJSTBPME5aUzFaSVgwQU9GTTNDQjdQUkxMMjc5UzRZN1BKSTBURVdSQUhLSFFZVVJOUw==",
            "email":"vhgalvez@gmail.com"
        },
        "registry.connect.redhat.com":{
            "auth":"fHVoYy1wb29sLWM1NzlhOGQ5LTA3YmItNDBmNy05OTgxLWNlODRlZmZhZDI2YTpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSTBPRGMxWVRVd01qSmlObU0wWW1KallqRXdNV0V3T1RjM01UQXhNR0k1WWlKOS5ZY0NRSl9XeldjLUFxNVc0UzlGNHE3ajNzbk9DelRmb3V0THRLS05EXzRWMGc2UWdGejZwdWh6N1pVcmEzUzFsUkptUXRWWUJETzFSRWtpT2tCYkR6UEVqVC1PSG1mSDhHcDRnTlN3TG5JZTRzeWdWMUMxWXBIU1NnUldncWlaaFBzMVlQTGJXazh6M0tfOEpNZlhtbUsyVS14dHVYeFVpbnMtLVo3NHd4MDdVWExtd2UwVk9DN0ROWDAwM0FGLUxhbFY5bnY4eVVMWnYzSlJnR0VjOFhuRkZxOWNrNWpCV2ZkVHhJd1VOdFBHYXpBcGhRZ0t1clloLWRmYVpLZkowaVRJVkV5RjBjR09DWWtPRlE0U2pJRE85b2xtZmhjektEblIyOEJSd2QtUE5JcEFzSk9teWRZRjVHdGdTNWtjZE9mV2dldUxxYjluUW1yMFExbXpzdmhhbnNsandxNFdtRUhaWFJ1dVo0NkU5cWVWMXgzZU51QzQyclF5d3dBUnRsdVJwNXpPam9SN3ViZHFHTldqLTIyWTZybi16aVZfbXRBV1R0eENsZjNPVTlqNWJDLU0yNTdIdWg3WGt1cFJ4bWZYcHVsSmpnZGlmQlIyaGNHMVNQVjBxT2pBZjA3NVRGZU5Yc2pOTlZnQWhFb2VmLTEtMHc4WGhISVdaZVBXT1lyRG9mR3dfcE1kclZqWWVUd19xSGpfQzAwa2lISmhOMkFQXzJRQnQzMHNhdVFuYk01c3g2WGpZUjBqNENDRTJaSDNJdkNOYWFNUHdreGJ4a0FaN3ZvbjhyWTNrZjAwa3RacFhmTjJPWDR4bHNFWmljZ0x6NFJjV2RHNFlVNG42cDJleVRPMWJCOEpYRmRpTjNZQmNhYkI3OFpnU1Y5bHlZWW52dTRacmtZRQ==",
            "email":"vhgalvez@gmail.com"
        },
        "registry.redhat.io":{
            "auth":"fHVoYy1wb29sLWM1NzlhOGQ5LTA3YmItNDBmNy05OTgxLWNlODRlZmZhZDI2YTpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSTBPRGMxWVRVd01qSmlObU0wWW1KallqRXdNV0V3T1RjM01UQXhNR0k1WWlKOS5ZY0NRSl9XeldjLUFxNVc0UzlGNHE3ajNzbk9DelRmb3V0THRLS05EXzRWMGc2UWdGejZwdWh6N1pVcmEzUzFsUkptUXRWWUJETzFSRWtpT2tCYkR6UEVqVC1PSG1mSDhHcDRnTlN3TG5JZTRzeWdWMUMxWXBIU1NnUldncWlaaFBzMVlQTGJXazh6M0tfOEpNZlhtbUsyVS14dHVYeFVpbnMtLVo3NHd4MDdVWExtd2UwVk9DN0ROWDAwM0FGLUxhbFY5bnY4eVVMWnYzSlJnR0VjOFhuRkZxOWNrNWpCV2ZkVHhJd1VOdFBHYXpBcGhRZ0t1clloLWRmYVpLZkowaVRJVkV5RjBjR09DWWtPRlE0U2pJRE85b2xtZmhjektEblIyOEJSd2QtUE5JcEFzSk9teWRZRjVHdGdTNWtjZE9mV2dldUxxYjluUW1yMFExbXpzdmhhbnNsandxNFdtRUhaWFJ1dVo0NkU5cWVWMXgzZU51QzQyclF5d3dBUnRsdVJwNXpPam9SN3ViZHFHTldqLTIyWTZybi16aVZfbXRBV1R0eENsZjNPVTlqNWJDLU0yNTdIdWg3WGt1cFJ4bWZYcHVsSmpnZGlmQlIyaGNHMVNQVjBxT2pBZjA3NVRGZU5Yc2pOTlZnQWhFb2VmLTEtMHc4WGhISVdaZVBXT1lyRG9mR3dfcE1kclZqWWVUd19xSGpfQzAwa2lISmhOMkFQXzJRQnQzMHNhdVFuYk01c3g2WGpZUjBqNENDRTJaSDNJdkNOYWFNUHdreGJ4a0FaN3ZvbjhyWTNrZjAwa3RacFhmTjJPWDR4bHNFWmljZ0x6NFJjV2RHNFlVNG42cDJleVRPMWJCOEpYRmRpTjNZQmNhYkI3OFpnU1Y5bHlZWW52dTRacmtZRQ==",
            "email":"vhgalvez@gmail.com"
        }
    }
}

EOF



cat >> pull_secret.json <<EOF
{
    "auths":{
        "cloud.openshift.com":{
            "auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfZTk5M2RiN2MwMDNkNDFlNDhmZGU4ZGE0OWIxZmZkYTI6WkhMMk5HUVFTS01aS1JJSTBPME5aUzFaSVgwQU9GTTNDQjdQUkxMMjc5UzRZN1BKSTBURVdSQUhLSFFZVVJOUw==",
            "email":"vhgalvez@gmail.com"
        },
        "quay.io":{
            "auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfZTk5M2RiN2MwMDNkNDFlNDhmZGU4ZGE0OWIxZmZkYTI6WkhMMk5HUVFTS01aS1JJSTBPME5aUzFaSVgwQU9GTTNDQjdQUkxMMjc5UzRZN1BKSTBURVdSQUhLSFFZVVJOUw==",
            "email":"vhgalvez@gmail.com"
        },
        "registry.connect.redhat.com":{
            "auth":"fHVoYy1wb29sLWM1NzlhOGQ5LTA3YmItNDBmNy05OTgxLWNlODRlZmZhZDI2YTpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSTBPRGMxWVRVd01qSmlObU0wWW1KallqRXdNV0V3T1RjM01UQXhNR0k1WWlKOS5ZY0NRSl9XeldjLUFxNVc0UzlGNHE3ajNzbk9DelRmb3V0THRLS05EXzRWMGc2UWdGejZwdWh6N1pVcmEzUzFsUkptUXRWWUJETzFSRWtpT2tCYkR6UEVqVC1PSG1mSDhHcDRnTlN3TG5JZTRzeWdWMUMxWXBIU1NnUldncWlaaFBzMVlQTGJXazh6M0tfOEpNZlhtbUsyVS14dHVYeFVpbnMtLVo3NHd4MDdVWExtd2UwVk9DN0ROWDAwM0FGLUxhbFY5bnY4eVVMWnYzSlJnR0VjOFhuRkZxOWNrNWpCV2ZkVHhJd1VOdFBHYXpBcGhRZ0t1clloLWRmYVpLZkowaVRJVkV5RjBjR09DWWtPRlE0U2pJRE85b2xtZmhjektEblIyOEJSd2QtUE5JcEFzSk9teWRZRjVHdGdTNWtjZE9mV2dldUxxYjluUW1yMFExbXpzdmhhbnNsandxNFdtRUhaWFJ1dVo0NkU5cWVWMXgzZU51QzQyclF5d3dBUnRsdVJwNXpPam9SN3ViZHFHTldqLTIyWTZybi16aVZfbXRBV1R0eENsZjNPVTlqNWJDLU0yNTdIdWg3WGt1cFJ4bWZYcHVsSmpnZGlmQlIyaGNHMVNQVjBxT2pBZjA3NVRGZU5Yc2pOTlZnQWhFb2VmLTEtMHc4WGhISVdaZVBXT1lyRG9mR3dfcE1kclZqWWVUd19xSGpfQzAwa2lISmhOMkFQXzJRQnQzMHNhdVFuYk01c3g2WGpZUjBqNENDRTJaSDNJdkNOYWFNUHdreGJ4a0FaN3ZvbjhyWTNrZjAwa3RacFhmTjJPWDR4bHNFWmljZ0x6NFJjV2RHNFlVNG42cDJleVRPMWJCOEpYRmRpTjNZQmNhYkI3OFpnU1Y5bHlZWW52dTRacmtZRQ==",
            "email":"vhgalvez@gmail.com"
        },
        "registry.redhat.io":{
            "auth":"fHVoYy1wb29sLWM1NzlhOGQ5LTA3YmItNDBmNy05OTgxLWNlODRlZmZhZDI2YTpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSTBPRGMxWVRVd01qSmlObU0wWW1KallqRXdNV0V3T1RjM01UQXhNR0k1WWlKOS5ZY0NRSl9XeldjLUFxNVc0UzlGNHE3ajNzbk9DelRmb3V0THRLS05EXzRWMGc2UWdGejZwdWh6N1pVcmEzUzFsUkptUXRWWUJETzFSRWtpT2tCYkR6UEVqVC1PSG1mSDhHcDRnTlN3TG5JZTRzeWdWMUMxWXBIU1NnUldncWlaaFBzMVlQTGJXazh6M0tfOEpNZlhtbUsyVS14dHVYeFVpbnMtLVo3NHd4MDdVWExtd2UwVk9DN0ROWDAwM0FGLUxhbFY5bnY4eVVMWnYzSlJnR0VjOFhuRkZxOWNrNWpCV2ZkVHhJd1VOdFBHYXpBcGhRZ0t1clloLWRmYVpLZkowaVRJVkV5RjBjR09DWWtPRlE0U2pJRE85b2xtZmhjektEblIyOEJSd2QtUE5JcEFzSk9teWRZRjVHdGdTNWtjZE9mV2dldUxxYjluUW1yMFExbXpzdmhhbnNsandxNFdtRUhaWFJ1dVo0NkU5cWVWMXgzZU51QzQyclF5d3dBUnRsdVJwNXpPam9SN3ViZHFHTldqLTIyWTZybi16aVZfbXRBV1R0eENsZjNPVTlqNWJDLU0yNTdIdWg3WGt1cFJ4bWZYcHVsSmpnZGlmQlIyaGNHMVNQVjBxT2pBZjA3NVRGZU5Yc2pOTlZnQWhFb2VmLTEtMHc4WGhISVdaZVBXT1lyRG9mR3dfcE1kclZqWWVUd19xSGpfQzAwa2lISmhOMkFQXzJRQnQzMHNhdVFuYk01c3g2WGpZUjBqNENDRTJaSDNJdkNOYWFNUHdreGJ4a0FaN3ZvbjhyWTNrZjAwa3RacFhmTjJPWDR4bHNFWmljZ0x6NFJjV2RHNFlVNG42cDJleVRPMWJCOEpYRmRpTjNZQmNhYkI3OFpnU1Y5bHlZWW52dTRacmtZRQ==",
            "email":"vhgalvez@gmail.com"
        }
    }
}
EOF




echo '{"auths":{"cloud.openshift.com":{"auth":"b3Blbn...etc"}}}' | jq .

 echo '{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfZTk5M2RiN2MwMDNkNDFlNDhmZGU4ZGE0OWIxZmZkYTI6WkhMMk5HUVFTS01aS1JJSTBPME5aUzFaSVgwQU9GTTNDQjdQUkxMMjc5UzRZN1BKSTBURVdSQUhLSFFZVVJOUw==","email":"vhgalvez@gmail.com"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfZTk5M2RiN2MwMDNkNDFlNDhmZGU4ZGE0OWIxZmZkYTI6WkhMMk5HUVFTS01aS1JJSTBPME5aUzFaSVgwQU9GTTNDQjdQUkxMMjc5UzRZN1BKSTBURVdSQUhLSFFZVVJOUw==","email":"vhgalvez@gmail.com"},"registry.connect.redhat.com":{"auth":"fHVoYy1wb29sLWM1NzlhOGQ5LTA3YmItNDBmNy05OTgxLWNlODRlZmZhZDI2YTpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSTBPRGMxWVRVd01qSmlObU0wWW1KallqRXdNV0V3T1RjM01UQXhNR0k1WWlKOS5ZY0NRSl9XeldjLUFxNVc0UzlGNHE3ajNzbk9DelRmb3V0THRLS05EXzRWMGc2UWdGejZwdWh6N1pVcmEzUzFsUkptUXRWWUJETzFSRWtpT2tCYkR6UEVqVC1PSG1mSDhHcDRnTlN3TG5JZTRzeWdWMUMxWXBIU1NnUldncWlaaFBzMVlQTGJXazh6M0tfOEpNZlhtbUsyVS14dHVYeFVpbnMtLVo3NHd4MDdVWExtd2UwVk9DN0ROWDAwM0FGLUxhbFY5bnY4eVVMWnYzSlJnR0VjOFhuRkZxOWNrNWpCV2ZkVHhJd1VOdFBHYXpBcGhRZ0t1clloLWRmYVpLZkowaVRJVkV5RjBjR09DWWtPRlE0U2pJRE85b2xtZmhjektEblIyOEJSd2QtUE5JcEFzSk9teWRZRjVHdGdTNWtjZE9mV2dldUxxYjluUW1yMFExbXpzdmhhbnNsandxNFdtRUhaWFJ1dVo0NkU5cWVWMXgzZU51QzQyclF5d3dBUnRsdVJwNXpPam9SN3ViZHFHTldqLTIyWTZybi16aVZfbXRBV1R0eENsZjNPVTlqNWJDLU0yNTdIdWg3WGt1cFJ4bWZYcHVsSmpnZGlmQlIyaGNHMVNQVjBxT2pBZjA3NVRGZU5Yc2pOTlZnQWhFb2VmLTEtMHc4WGhISVdaZVBXT1lyRG9mR3dfcE1kclZqWWVUd19xSGpfQzAwa2lISmhOMkFQXzJRQnQzMHNhdVFuYk01c3g2WGpZUjBqNENDRTJaSDNJdkNOYWFNUHdreGJ4a0FaN3ZvbjhyWTNrZjAwa3RacFhmTjJPWDR4bHNFWmljZ0x6NFJjV2RHNFlVNG42cDJleVRPMWJCOEpYRmRpTjNZQmNhYkI3OFpnU1Y5bHlZWW52dTRacmtZRQ==","email":"vhgalvez@gmail.com"}}}' | jq .
