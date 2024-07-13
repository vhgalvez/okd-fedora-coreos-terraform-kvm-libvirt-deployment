### Guía de Instalación de OKD (OpenShift Kubernetes Distribution) Multinodo en KVM

#### Requisitos Previos

- **Servidor con KVM y libvirt instalados**
- **Sistema Operativo:** Rocky Linux 9.3 o similar
- **Terraform:** v0.13 o superior
- **Acceso a un servidor DNS (FreeIPA) configurado**
- **Llave SSH configurada**

#### Introducción

OKD (OpenShift Kubernetes Distribution) es una distribución de Kubernetes de código abierto que incluye herramientas y características adicionales para facilitar la administración y el despliegue de aplicaciones en contenedores. En esta guía, aprenderás a instalar un clúster OKD multinodo en KVM con los pasos necesarios y las configuraciones específicas para asegurar un despliegue exitoso.

---

#### Paso 1: Conectar y Preparar el Nodo Bootstrap

Accede al nodo bootstrap1:

```bash
sudo ssh -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift core@10.17.3.14 -p 22
```

##### 1.1 Instalar paquetes necesarios

Instala `wget` y otros paquetes necesarios:

```bash
sudo dnf install -y wget tar
```

##### 1.2 Descargar el Cliente de OpenShift (oc)

Descarga el cliente de OpenShift:

```bash
wget https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-03-18-084815/openshift-client-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
```

##### 1.3 Extraer y Mover el Cliente

```bash
tar -xzvf openshift-client-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
sudo mv oc /usr/local/bin/
sudo chmod +x /usr/local/bin/oc
```

##### 1.4 Verificar la Instalación

```bash
oc version
```

---

#### Paso 2: Descargar e Instalar el Instalador de OKD

##### 2.1 Descargar openshift-install

```bash
wget https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-03-18-084815/openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
```

##### 2.2 Extraer y Mover el Instalador

```bash
tar -xzvf openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
sudo mv openshift-install /usr/local/bin/
sudo chmod +x /usr/local/bin/openshift-install
```

---

#### Paso 3: Configurar el DNS en FreeIPA

##### 3.1 Añadir Entradas DNS

Conéctate a tu servidor FreeIPA y autentícate como administrador:

```bash
sudo ssh -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift core@10.17.3.11 -p 22
```

Autentícate como administrador en FreeIPA:

```bash
kinit admin
Password for admin@CEFASLOCALSERVER.COM:
```

Configura las entradas DNS necesarias para tu clúster en FreeIPA:

```bash
ipa dnsrecord-add cefaslocalserver.com api.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com api-int.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master1.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master2.produccion --a-rec=10.17.4.22
ipa dnsrecord-add cefaslocalserver.com master3.produccion --a-rec=10.17.4.23
ipa dnsrecord-add cefaslocalserver.com worker1.produccion --a-rec=10.17.4.24
ipa dnsrecord-add cefaslocalserver.com worker2.produccion --a-rec=10.17.4.25
ipa dnsrecord-add cefaslocalserver.com worker3.produccion --a-rec=10.17.4.26
```

---

#### Paso 4: Transferir Archivos Ignition al Nodo Bootstrap

##### 4.1 Transferir los Archivos Ignition

Desde el servidor físico donde se generaron los archivos Ignition:

```bash
sudo scp -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift /home/victory/terraform-openshift-kvm-deployment_linux_Flatcar/nat_network_03/ignition-configs/*.ign core@10.17.3.14:/home/core/
```

---

#### Paso 5: Crear el Archivo de Configuración de Instalación

##### 5.1 Crear `install-config.yaml`

En el nodo bootstrap, crea el archivo `install-config.yaml`:

```bash
nano /home/core/okd-install/install-config.yaml
```

Y agrega el siguiente contenido:

```yaml
apiVersion: v1
baseDomain: cefaslocalserver.com
metadata:
  name: produccion
compute:
- name: worker
  replicas: 3
controlPlane:
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
```

---

#### Paso 6: Generar y Aplicar Manifiestos

##### 6.1 Generar Manifiestos

En el nodo bootstrap, genera los manifiestos:

```bash
openshift-install create manifests --dir=/home/core/okd-install
```

##### 6.2 Generar Configuraciones Ignition

En el nodo bootstrap, genera las configuraciones Ignition:

```bash
openshift-install create ignition-configs --dir=/home/core/okd-install
```

---

#### Paso 7: Crear el Clúster

##### 7.1 Iniciar la Instalación

Inicia la instalación del clúster de OKD:

```bash
openshift-install create cluster --dir=/home/core/okd-install --log-level=debug
```

---

#### Paso 8: Verificar la Instalación

##### 8.1 Verificar Nodos

Verifica que todos los nodos del clúster estén funcionando correctamente:

```bash
oc get nodes
```

##### 8.2 Aprobar Solicitudes de Certificado (CSR)

Aprobar las solicitudes de certificados que sean necesarias para que los nodos se unan al clúster:

```bash
oc get csr
oc certificate approve <CSR_NAME>
```

---

#### Paso 9: Completar la Instalación

##### 9.1 Esperar la Finalización

Sigue los logs y espera a que la instalación se complete:

```bash
openshift-install --dir=/home/core/okd-install wait-for install-complete --log-level=debug
```

---

#### Recursos Adicionales
Para más detalles y pasos avanzados, consulta los siguientes recursos:
- [Documentación de OKD](https://docs.okd.io/latest/welcome/index.html)
- [Guía de instalación de OKD](https://docs.okd.io/latest/installing/index.html)
- [Releases de OKD en GitHub](https://github.com/okd-project/okd/releases)

---

### Arquitectura del Clúster OKD

- **IP Pública:** 192.168.0.21
- **Load Balancer (Traefik, IP: 10.17.3.12):** Distribuye el tráfico entrante a los nodos maestros.
- **Nodos Maestros:** Master 1, Master 2, Master 3
- **Nodo Bootstrap (IP: 10.17.3.14):** Utilizado durante la configuración inicial del clúster.
- **Nodos Trabajadores:** Worker 1, Worker 2, Worker 3
- **FreeIPA (IP: 10.17.3.11):** Proporciona servicios de DNS y gestión de identidades.
- **Nodo Bastion (IP: 192.168.0.20):** Punto de acceso seguro para la gestión del clúster.

### Entradas DNS
Configura las siguientes entradas DNS en FreeIPA:

```bash
ipa dnsrecord-add cefaslocalserver.com api.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com api-int.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master1.produccion --a-rec=10.17.4.21
```

### Función del Balanceador de Carga (Traefik)
El Balanceador de Carga (Traefik) con la IP 10.17.3.12 se utiliza para distribuir el tráfico entrante entre los nodos maestros. Aunque `api.produccion` y `api-int.produccion` apuntan