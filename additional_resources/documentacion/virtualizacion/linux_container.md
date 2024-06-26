
Tutorial para Instalar Flatcar Linux en una Máquina Virtual Usando libvirt y QEMU
Paso 1: Descargar la Imagen
Crear un directorio y descargar la imagen:
bash
Copiar código
mkdir -p /var/lib/libvirt/images/flatcar-linux
cd /var/lib/libvirt/images/flatcar-linux
wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_image.img{,.sig}
gpg --verify flatcar_production_qemu_image.img.sig
Paso 2: Crear una Imagen QCOW2
Crear una imagen snapshot:
bash
Copiar código
cd /var/lib/libvirt/images/flatcar-linux
qemu-img create -f qcow2 -F qcow2 -b flatcar_production_qemu_image.img flatcar-linux1.qcow2
Estos pasos te permitirán descargar la imagen de Flatcar Linux y preparar una imagen snapshot en formato QCOW2 para su uso con QEMU y libvirt.