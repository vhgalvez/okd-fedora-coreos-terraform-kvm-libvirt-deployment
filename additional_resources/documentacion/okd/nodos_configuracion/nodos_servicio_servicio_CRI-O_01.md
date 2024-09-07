
# Configuración de Nodos Master

## 1. Instalación de Servicio CRI-O

  
```bash
sudo systemctl status crio
```


```bash
/etc/systemd/system/crio.service
```

```bash
[Unit]
Description=CRI-O container runtime
After=network.target

[Service]
Type=notify
ExecStart=/opt/bin/crio/crio
Environment="PATH=/opt/bin/crio:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Restart=always
RestartSec=5
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
```


```bash
sudo systemctl daemon-reload
sudo systemctl restart crio
sudo systemctl status crio
sudo journalctl -u crio
```