# Guía de Instalación de OKD (OpenShift Kubernetes Distribution) Multinodo en KVM

## Requisitos Previos

- **Servidor con KVM y libvirt instalados**
- **Sistema Operativo:** Rocky Linux 9.3 o similar
- **Terraform:** v0.13 o superior
- **Acceso a un servidor DNS (FreeIPA) configurado**
- **Llave SSH configurada**

## Paso 3: Descargar el Instalador de OKD

### 3.1 Descargar openshift-install

Utiliza wget para descargar la versión correcta del instalador de OKD desde GitHub.

```bash
wget https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-03-18-084815/openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
```

### 3.2 Verificar y Extraer el Archivo

Verifica que el archivo se haya descargado completamente y extráelo.

```bash
ls -lh openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
tar -xzvf openshift-install-linux-4.12.0-0.okd-2023-03-18-084815.tar.gz
sudo mv openshift-install /usr/local/bin/
```
## Paso 4: Configurar el DNS en FreeIPA

### 4.1 Añadir Entradas DNS

Conéctate a tu servidor FreeIPA y autentícate como administrador.
```bash
[victory@physical1 ~]$  sudo ssh -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift  core@10.17.3.11 -p 22
```

Autentícate como administrador en FreeIPA.
```bash
[core@freeipa1 ~]$ kinit admin
```
12345678

Configura las entradas DNS necesarias para tu clúster en FreeIPA. Estas entradas permiten el correcto funcionamiento y acceso a los componentes del clúster.

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
## Paso 5: Crear el Archivo de Configuración de Instalación

### 5.1 Crear install-config.yaml

Crea el archivo `install-config.yaml` con la configuración básica para tu clúster y guárdalo en el directorio de trabajo `/home/core/okd-install`.

```yaml
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
```

## Paso 6: Generar y Aplicar Manifiestos

### 6.1 Generar Manifiestos

Genera los manifiestos necesarios para la instalación de OKD.

```bash
openshift-install create manifests --dir=/home/core/okd-install
```

### 6.2 Generar Configuraciones Ignition

Dado que Terraform ya gestiona la creación de las configuraciones Ignition, este paso puede omitirse aquí. Pero normalmente, si no estuviera automatizado, sería necesario:

```bash
openshift-install create ignition-configs --dir=/home/core/okd-install
```

## Paso 7: Crear el Clúster

### 7.1 Iniciar la Instalación

Inicia la instalación del clúster de OKD.

```bash
openshift-install create cluster --dir=/home/core/okd-install --log-level=debug
```
## Paso 8: Verificar la Instalación

### 8.1 Verificar Nodos

Verifica que todos los nodos del clúster estén funcionando correctamente.


```bash
oc get nodes
```
### 8.2 Aprobar Solicitudes de Certificado (CSR)

Aprobar las solicitudes de certificados que sean necesarias para que los nodos se unan al clúster.

```bash
oc get csr
oc certificate approve <CSR_NAME>
```

## Paso 9: Completar la Instalación

### 9.1 Esperar la Compleción

Sigue los logs y espera a que la instalación se complete.


```bash
openshift-install --dir=/home/core/okd-install wait-for install-complete --log-level=debug
```


## Recursos Adicionales

Para más detalles y pasos avanzados, consulta los siguientes recursos:

- [Documentación de OKD](https://docs.okd.io)
- [Guía de instalación de OKD](https://docs.okd.io/latest/installing/index.html)
- [Releases de OKD en GitHub](https://github.com/okd-project/okd/releases)

## Explicación de las Entradas DNS y el Rol del Balanceador de Carga (Traefik)

### Arquitectura del Clúster OKD

- **IP Pública (192.168.0.21):** La dirección IP accesible desde el exterior para conexiones HTTPS.
- **Load Balancer (Traefik, IP: 10.17.3.12):** Distribuye el tráfico entrante a los nodos maestros.
- **Nodos Maestros:** (Master 1, Master 2, Master 3): Gestionan el plano de control del clúster.
- **Nodo Bootstrap (IP: 10.17.3.12):** Utilizado durante la configuración inicial del clúster.
- **Nodos Trabajadores:** (Worker 1, Worker 2, Worker 3): Ejecutan las aplicaciones desplegadas en el clúster.
- **FreeIPA (IP: 10.17.3.11):** Proporciona servicios de DNS y gestión de identidades.
- **Nodo Bastion (IP: 192.168.0.20):** Punto de acceso seguro para la gestión del clúster.

### Entradas DNS

Estas entradas DNS se configuran para facilitar el acceso a diferentes componentes del clúster.

```bash
ipa dnsrecord-add cefaslocalserver.com api.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com api-int.produccion --a-rec=10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master1.produccion --a-rec=10.17.4.21
```

### Propósitos de las Entradas DNS

- **api.produccion (10.17.4.21):**
  - **Propósito:** Facilita el acceso externo a la API del clúster OKD.
  - **Uso:** Utilizado por desarrolladores, herramientas CI/CD y otros usuarios externos para interactuar con el clúster.

- **api-int.produccion (10.17.4.21):**
  - **Propósito:** Facilita el acceso interno a la API del clúster OKD.
  - **Uso:** Utilizado por componentes internos del clúster para comunicarse entre sí, optimizando la eficiencia y reduciendo la carga en el balanceador de carga.

- **master1.produccion (10.17.4.21):**
  - **Propósito:** Permite el acceso directo al primer nodo maestro.
  - **Uso:** Utilizado para tareas de administración, mantenimiento y monitoreo específico del nodo maestro.

### Función del Balanceador de Carga (Traefik)

El Balanceador de Carga (Traefik) con la IP 10.17.3.12 se utiliza para distribuir el tráfico entrante entre los nodos maestros. Aunque `api.produccion` y `api-int.produccion` apuntan a la misma IP (10.17.4.21), en la práctica, el balanceador de carga dirige este tráfico a los nodos maestros disponibles.

### Diagramas de Flujo de Conexión

**Conexiones Entrantes:**

- **Traefik:** Las conexiones HTTPS entrantes llegan a Traefik y se distribuyen entre los nodos maestros.
- **DNS:** Las entradas DNS (`api.produccion` y `api-int.produccion`) apuntan a la IP manejada por Traefik, facilitando el balanceo de carga.

**Comunicación Interna y Externa:**

- **Interna:** `api-int.produccion` asegura la comunicación entre componentes internos del clúster.
- **Externa:** `api.produccion` gestiona el acceso externo al clúster.

Esta guía te ayudará a instalar un clúster OKD multinodo en KVM con los pasos necesarios y las configuraciones específicas para asegurar un despliegue exitoso.
