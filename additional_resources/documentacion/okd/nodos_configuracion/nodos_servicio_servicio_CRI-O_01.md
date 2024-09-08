
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

Verify CRI-O Path Configuration:
The CRI-O binary is located in /opt/bin/crio/. You can add this path to your system's PATH variable, so the shell recognizes it.

Run the following command to temporarily add the path to your session:

bash
Copiar código
export PATH=$PATH:/opt/bin/crio
To make the change permanent, you can add this line to your shell profile (for example, ~/.bashrc or /etc/profile):

bash
Copiar código
echo 'export PATH=$PATH:/opt/bin/crio' >> ~/.bashrc
Then reload the profile:

bash
Copiar código
source ~/.bashrc