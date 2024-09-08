
# Guía para la Preparación de Nodos para la Instalación de OKD
============================================================
Esta guía cubre los pasos para preparar correctamente los nodos master y worker en un clúster OKD. Esto incluye la configuración del servicio kubelet, la red CNI, y otros componentes necesarios para asegurar que los nodos se unan correctamente al clúster durante la instalación de OKD.

____________________________________________________________

## 1. Introducción al Servicio Kubelet

El servicio kubelet es fundamental en cada nodo del clúster OKD. Es responsable de:

* Registrar el nodo en el clúster
* Gestionar los pods y contenedores
* Comunicar el estado del nodo al kube-apiserver

Si el kubelet no está correctamente configurado o no puede comunicarse con el API de Kubernetes, los nodos no aparecerán en el clúster y los recursos no podrán ser gestionados adecuadamente.

## 2. Configurar el Servicio Kubelet

### 2.1 Archivo de Servicio `kubelet.service`


Este archivo de servicio asegura que `kubelet` se inicie junto con el runtime de contenedores `CRI-O` y se reinicie automáticamente si falla.


```bash
cat /etc/systemd/system/kubelet.service
```

```bash
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
Wants=crio.service
After=crio.service

[Service]
ExecStart=/opt/bin/kubelet --config=/etc/kubernetes/kubelet-config.yaml --kubeconfig=/etc/kubernetes/kubelet.conf
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Puntos Clave:**

* `crio.service` es el contenedor runtime.

* La configuración del `kubelet` está en `/etc/kubernetes/kubelet-config.yaml` y `/etc/kubernetes/kubelet.conf`.
  

