
# Descargar e instalar OpenShift Installer (OKD v4.14.0)


sudo mkdir -p /usr/local/bin/

sudo curl --retry 5 --retry-delay 10 -L -o /tmp/openshift-install.tar.gz "https://github.com/openshift/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-install-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz"


4.15.0-0.okd-2024-03-10-010116

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




sudo mkdir -p /usr/local/bin/

sudo curl --retry 5 --retry-delay 10 -L -o /tmp/openshift-install.tar.gz "https://github.com/openshift/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-install-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz"


sudo tar -xzf /tmp/openshift-install.tar.gz -C /tmp
sudo mv /tmp/openshift-install /usr/local/bin/
sudo chmod +x /usr/local/bin/openshift-install
sudo rm -rf /tmp/openshift-install.tar.gz
openshift-install version






sudo chmod -R 755 
sudo chown -R core:core




sudo scp -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift \
/home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/*.ign \
core@10.17.3.14:/home/core/nginx-docker/okd/



sudo chcon -t svirt_home_t /home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/okd-install/*.ign

curl -o /mnt/lv_data/organized_storage/volumes/volumetmp_03/bootstrap.ign http://10.17.3.14/okd/bootstrap.ign



curl http://10.17.3.14/okd/bootstrap.ign
curl http://10.17.3.14/okd/master.ign
curl http://10.17.3.14/okd/worker.ign



resource "libvirt_volume" "ignition_volumes" {
  for_each = {
    "bootstrap" = "http://10.17.3.14/okd/bootstrap.ign"
    "master1"   = "http://10.17.3.14/okd/master.ign"
    "master2"   = "http://10.17.3.14/okd/master.ign"
    "master3"   = "http://10.17.3.14/okd/master.ign"
    "worker1"   = "http://10.17.3.14/okd/worker.ign"
    "worker2"   = "http://10.17.3.14/okd/worker.ign"
    "worker3"   = "http://10.17.3.14/okd/worker.ign"
  }

  name     = "${each.key}-ignition"
  pool     = libvirt_pool.volumetmp_03.name
  source   = each.value
  format   = "qcow2"
}


sudo terraform state rm 'local_file.ignition_configs["bootstrap"]'
sudo terraform state rm 'local_file.ignition_configs["master1"]'
sudo terraform state rm 'local_file.ignition_configs["master2"]'
sudo terraform state rm 'local_file.ignition_configs["master3"]'
sudo terraform state rm 'local_file.ignition_configs["worker1"]'
sudo terraform state rm 'local_file.ignition_configs["worker2"]'
sudo terraform state rm 'local_file.ignition_configs["worker3"]'
