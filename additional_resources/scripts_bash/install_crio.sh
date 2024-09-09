#!/bin/bash

# Crear directorios necesarios
sudo mkdir -p /opt/bin /etc/kubernetes/pki /opt/cni/bin /etc/kubernetes/pki/etcd
sudo mkdir -p /opt/cni/bin
sudo mkdir -p  /home/core/bin/mksquashfs
sudo mkdir -p /home/core/bin

export PATH=$PATH:/home/core/bin


# Descargar e instalar CRI-O (v1.30.5)
sudo wget -O /tmp/crio.tar.gz https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.5.tar.gz
sudo tar -xzf /tmp/crio.tar.gz -C /opt/cni/bin/
sudo cp /opt/bin/crio/cri-o/cni-plugins/* /opt/cni/bin/


sudo systemctl daemon-reload
sudo systemctl enable extensions-crio.slice
sudo systemctl start extensions-crio.slice

sudo mount -o remount,rw /
mount | grep " / "

sudo docker run -it --rm alpine
apk add squashfs-tools


Copia el binario mksquashfs al sistema Flatcar:

Primero, abre una nueva ventana de terminal y busca el ID del contenedor de Alpine que está corriendo:

sudo docker ps

sudo chmod +x /usr/local/bin/mksquashfs




sudo docker cp <container_id>:/usr/bin/mksquashfs /home/core/bin/mksquashfs
sudo chmod +x /home/core/bin/mksquashfs


sudo docker cp ad2c56e6dfe9:/usr/bin/mksquashfs /home/core/bin/mksquashfs
sudo chmod +x /home/core/bin/mksquashfs



sudo mkdir -p /home/core/bin
sudo docker cp fdbabb749b1d:/usr/bin/mksquashfs /home/core/bin/mksquashfs
sudo chmod +x /home/core/bin/mksquashfs


sudo mkdir -p /home/core/bin/mksquashfs
export PATH=$PATH:/home/core/bin

/home/core/bin/mksquashfs --version


sudo wget https://raw.githubusercontent.com/flatcar/sysext-bakery/main/bake.sh -O bake.sh
sudo chmod +x bake.sh
sudo ./bake.sh

sudo wget https://raw.githubusercontent.com/flatcar/sysext-bakery/main/create_crio_sysext.sh -O create_crio_sysext.sh
sudo chmod +x create_crio_sysext.sh
sudo ./create_crio_sysext.sh 1.30.5 crio-sysext



sudo /usr/local/bin/crio/cri-o/install


ls -l /opt/bin/crio/crio
sudo systemctl daemon-reload
sudo systemctl start crio
sudo systemctl enable --now crio




sudo docker exec -it 1d423cbb6ce3 /bin/sh
apk add lz4-libs lzo zstd-libs xz-libs

sudo docker cp 1d423cbb6ce3:/usr/lib/liblz4.so.1 /home/core/lib/
sudo docker cp 1d423cbb6ce3:/usr/lib/liblzo2.so.2 /home/core/lib/
sudo docker cp 1d423cbb6ce3:/usr/lib/libzstd.so.1 /home/core/lib/
sudo docker cp 1d423cbb6ce3:/usr/lib/libz.so.1 /home/core/lib/
sudo docker cp 1d423cbb6ce3:/usr/lib/liblzma.so.5 /home/core/lib/


export LD_LIBRARY_PATH=/home/core/lib:$LD_LIBRARY_PATH
/home/core/lib/ld-musl-x86_64.so.1 --library-path /home/core/lib /home/core/bin/mksquashfs --version







sudo docker exec -it <container_id> /bin/sh
apk add lz4-libs lzo zstd-libs xz-libs
sudo docker cp <container_id>:/usr/lib/liblz4.so.1 /home/core/lib/
sudo docker cp <container_id>:/usr/lib/liblzo2.so.2 /home/core/lib/
sudo docker cp <container_id>:/usr/lib/libzstd.so.1 /home/core/lib/
sudo docker cp <container_id>:/usr/lib/libz.so.1 /home/core/lib/
sudo docker cp <container_id>:/usr/lib/liblzma.so.5 /home/core/lib/



export LD_LIBRARY_PATH=/home/core/lib:$LD_LIBRARY_PATH
/home/core/bin/mksquashfs --version






# Verifica el estado de la partición raíz
mount | grep " / "

# Verifica el estado de SELinux
getenforce

# Cambia temporalmente SELinux a modo permisivo
sudo setenforce 0

# Remonta la partición raíz con permisos de escritura
sudo mount -o remount,rw /

# Verifica errores en el sistema de archivos
sudo dmesg | grep "EXT4-fs error"
sudo fsck /dev/vda9  # Reemplaza con la partición correcta si es diferente

# Si fsck no puede ejecutarse, crea un archivo para forzar el chequeo al reiniciar
sudo touch /forcefsck

# Reinicia el sistema para ejecutar fsck automáticamente
sudo reboot

# Intenta extraer archivos en un directorio diferente si /usr/local/bin/ está en modo solo lectura
sudo mkdir -p /home/core/crio/
sudo tar -xzf /tmp/crio.tar.gz -C /home/core/crio/





core@bootstrap ~ $ sudo mount | grep " / "
/dev/vda9 on / type ext4 (rw,relatime,seclabel)
core@bootstrap ~ $ sudo mount -o remount,rw /
core@bootstrap ~ $ mount | grep " / "
/dev/vda9 on / type ext4 (rw,relatime,seclabel)
core@bootstrap ~ $ sudo dmesg | grep "EXT4-fs error"
core@bootstrap ~ $ sudo touch /forcefsck
core@bootstrap ~ $
sudo reboot

https://www.flatcar.org/  https://okd.io/ https://www.redhat.com/es
https://docs.okd.io/3.11/crio/crio_runtime.html
https://github.com/okd-project/okd https://cri-o.io/
https://kubernetes.io/