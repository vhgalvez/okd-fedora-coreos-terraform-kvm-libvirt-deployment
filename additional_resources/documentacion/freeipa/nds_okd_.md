# Configuración de Resolución de DNS en OKD/OpenShift

Este documento describe la configuración adecuada de las entradas DNS para tu entorno de OKD/OpenShift, incluyendo las direcciones IP y los nombres de dominio correspondientes. Estas entradas son esenciales para garantizar la correcta resolución de los nodos del clúster y los servicios de OpenShift.

## Entradas DNS para Nodos y Servicios Clave

### Nodos Principales
Aquí se listan los nodos principales con sus respectivas direcciones IP y nombres de dominio:

| **Rol**              | **Hostname**                              | **IP Address**  |
|----------------------|-------------------------------------------|----------------|
| **FreeIPA (DNS)**     | `freeipa1.cefaslocalserver.com`           | `10.17.3.11`   |
| **Load Balancer**     | `load_balancer1.cefaslocalserver.com`     | `10.17.3.12`   |
| **PostgreSQL**        | `postgresql1.cefaslocalserver.com`        | `10.17.3.13`   |
| **Helper Node**       | `helper.cefaslocalserver.com`             | `10.17.3.14`   |
| **Control Plane 1**   | `controlplane1.cefaslocalserver.com`      | `10.17.3.22`   |
| **Control Plane 2**   | `controlplane2.cefaslocalserver.com`      | `10.17.3.23`   |
| **Control Plane 3**   | `controlplane3.cefaslocalserver.com`      | `10.17.3.24`   |
| **Worker 1**          | `worker1.cefaslocalserver.com`            | `10.17.3.25`   |
| **Worker 2**          | `worker2.cefaslocalserver.com`            | `10.17.3.26`   |
| **Worker 3**          | `worker3.cefaslocalserver.com`            | `10.17.3.27`   |
| **Bootstrap Node**    | `bootstrap.cefaslocalserver.com`          | `10.17.3.21`   |

### Entradas DNS Específicas de OpenShift
Las siguientes entradas DNS son críticas para el correcto funcionamiento de los servicios API de OpenShift, OAuth, y la consola web:

| **Servicio**               | **Hostname**                                         | **IP Address**        |
|----------------------------|-----------------------------------------------------|-----------------------|
| **API de OpenShift**        | `api.local.cefaslocalserver.com`                    | `10.17.3.22` (Control Plane 1) |
|                            | `api.local.cefaslocalserver.com`                    | `10.17.3.23` (Control Plane 2) |
|                            | `api.local.cefaslocalserver.com`                    | `10.17.3.24` (Control Plane 3) |
| **API Interna de OpenShift**| `api-int.local.cefaslocalserver.com`                | `10.17.3.22` (Control Plane 1) |
|                            | `api-int.local.cefaslocalserver.com`                | `10.17.3.23` (Control Plane 2) |
|                            | `api-int.local.cefaslocalserver.com`                | `10.17.3.24` (Control Plane 3) |
| **OAuth OpenShift**         | `oauth-openshift.apps.local.cefaslocalserver.com`   | `10.17.3.22`           |
| **Consola OpenShift**       | `console-openshift-console.apps.local.cefaslocalserver.com` | `10.17.3.22`    |
| **Cluster de Etcd**         | `etcd-0.local.cefaslocalserver.com`                 | `10.17.3.22` (Control Plane 1) |
|                            | `etcd-1.local.cefaslocalserver.com`                 | `10.17.3.23` (Control Plane 2) |
|                            | `etcd-2.local.cefaslocalserver.com`                 | `10.17.3.24` (Control Plane 3) |

## Notas sobre la Resolución de DNS

1. **API de OpenShift**: Las entradas `api.local.cefaslocalserver.com` y `api-int.local.cefaslocalserver.com` deben resolverse a las direcciones IP de los planos de control (Control Plane).
   
2. **Cluster de Etcd**: Asegúrate de configurar correctamente los servidores `etcd` con registros SRV si es necesario para la correcta detección de servicios en OpenShift.

3. **OAuth y Consola Web**: Los puntos finales para la autenticación y la consola web, como `oauth-openshift.apps.local.cefaslocalserver.com` y `console-openshift-console.apps.local.cefaslocalserver.com`, deben resolverse correctamente a las IPs del plano de control.

4. **Balanceador de Carga**: Verifica que `load_balancer1.cefaslocalserver.com` apunte a la IP correcta del balanceador de carga (10.17.3.12).

5. **Wildcard DNS**: Si estás configurando registros de wildcard, asegúrate de que cualquier subdominio de `*.cefaslocalserver.com` resuelva a la IP adecuada.

## Conclusión
Una vez que se configuren correctamente estos registros en tu servicio DNS, como FreeIPA o cualquier otro, los componentes de OpenShift deberían poder resolver los nombres de dominio correctamente y funcionar sin problemas.

Si necesitas asistencia adicional, no dudes en contactarme.


# Entradas DNS para Instalación de OKD en FreeIPA

Este documento proporciona una lista completa de entradas DNS necesarias para la instalación de OKD en el dominio `cefaslocalserver.com`. Asegúrate de que estas entradas estén correctamente configuradas en el servidor FreeIPA antes de proceder con la instalación.

| **Rol**                   | **Nombre DNS**                                | **Dirección IP**       | **Descripción**                                            |
|---------------------------|-----------------------------------------------|------------------------|------------------------------------------------------------|
| **FreeIPA (DNS)**          | `freeipa1.cefaslocalserver.com`               | 10.17.3.11             | Servidor DNS para la gestión de identidades y resolución DNS.|
| **Balanceador de Carga**   | `load_balancer1.cefaslocalserver.com`         | 10.17.3.12             | Balanceador de carga para el tráfico entrante del clúster.  |
| **PostgreSQL**             | `postgresql1.cefaslocalserver.com`            | 10.17.3.13             | Servidor de base de datos PostgreSQL.                       |
| **Nodo Helper**            | `helper.cefaslocalserver.com`                 | 10.17.3.14             | Nodo de soporte para la instalación y gestión de OKD.       |
| **Control Plane 1**        | `controlplane1.cefaslocalserver.com`          | 10.17.3.22             | Primer nodo del plano de control.                           |
| **Control Plane 2**        | `controlplane2.cefaslocalserver.com`          | 10.17.3.23             | Segundo nodo del plano de control.                          |
| **Control Plane 3**        | `controlplane3.cefaslocalserver.com`          | 10.17.3.24             | Tercer nodo del plano de control.                           |
| **Worker 1**               | `worker1.cefaslocalserver.com`                | 10.17.3.25             | Primer nodo de trabajo para la ejecución de aplicaciones.   |
| **Worker 2**               | `worker2.cefaslocalserver.com`                | 10.17.3.26             | Segundo nodo de trabajo para la ejecución de aplicaciones.  |
| **Worker 3**               | `worker3.cefaslocalserver.com`                | 10.17.3.27             | Tercer nodo de trabajo para la ejecución de aplicaciones.   |
| **Bootstrap Node**         | `bootstrap.cefaslocalserver.com`              | 10.17.3.21             | Nodo de bootstrap usado durante la instalación de OKD.      |

## Entradas DNS Específicas de OpenShift

Estas entradas son necesarias para la correcta resolución de los servicios internos y externos de OpenShift. Deben estar configuradas para que los componentes clave del clúster puedan comunicarse correctamente.

| **Rol**                   | **Nombre DNS**                                | **Dirección IP**       | **Descripción**                                            |
|---------------------------|-----------------------------------------------|------------------------|------------------------------------------------------------|
| **OpenShift API**          | `api.local.cefaslocalserver.com`              | 10.17.3.22, 10.17.3.23, 10.17.3.24 | API pública de OpenShift, apuntando a los nodos de control.|
| **API Interna**            | `api-int.local.cefaslocalserver.com`          | 10.17.3.22, 10.17.3.23, 10.17.3.24 | API interna para la comunicación dentro del clúster.       |
| **OAuth OpenShift**        | `oauth-openshift.apps.local.cefaslocalserver.com` | 10.17.3.22 | Servicio OAuth de OpenShift.                              |
| **Console OpenShift**      | `console-openshift-console.apps.local.cefaslocalserver.com` | 10.17.3.22 | Consola web de OpenShift.                                 |
| **Etcd 0**                 | `etcd-0.local.cefaslocalserver.com`           | 10.17.3.22             | Primer nodo del clúster etcd.                              |
| **Etcd 1**                 | `etcd-1.local.cefaslocalserver.com`           | 10.17.3.23             | Segundo nodo del clúster etcd.                             |
| **Etcd 2**                 | `etcd-2.local.cefaslocalserver.com`           | 10.17.3.24             | Tercer nodo del clúster etcd.                              |

## Notas para la Configuración Correcta del DNS

1. **Entradas API de OpenShift**: Las entradas de la API (`api.local.cefaslocalserver.com` y `api-int.local.cefaslocalserver.com`) deben apuntar a las IPs de los nodos del plano de control para que los servicios críticos de OpenShift puedan comunicarse adecuadamente.

2. **Clúster Etcd**: Los nodos de etcd requieren entradas DNS específicas, incluidas las entradas SRV para la detección de servicios. Asegúrate de que estos registros SRV estén correctamente configurados.

3. **OAuth y Consola**: Las entradas DNS para OAuth y la consola (`oauth-openshift` y `console-openshift-console`) deben apuntar a los nodos de control.

4. **Balanceador de Carga**: El dominio `load_balancer1.cefaslocalserver.com` debe apuntar a la IP del nodo de balanceo de carga para dirigir el tráfico hacia el clúster.

---

Este documento debe utilizarse como referencia para la configuración correcta de DNS en tu servidor FreeIPA antes de la instalación de OKD.
