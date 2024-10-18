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
