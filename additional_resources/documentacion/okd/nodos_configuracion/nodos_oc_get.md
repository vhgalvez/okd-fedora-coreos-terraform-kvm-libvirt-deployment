Parece que estás enfrentando algunos problemas para configurar la variable KUBECONFIG de manera persistente y usarla sin problemas. Vamos a corregirlo paso a paso.

1. Configurar la variable KUBECONFIG correctamente
En tu caso, has intentado usar source en el archivo .bashrc con sudo, pero no funcionó correctamente. Esto ocurre porque source no es un comando que se puede ejecutar con sudo. Debes asegurarte de que la variable esté configurada correctamente tanto para el usuario root como para cualquier otro usuario que estés utilizando.

1.1. Editar el archivo .bashrc de root
Ya has abierto y editado el archivo .bashrc de root. Asegúrate de que agregaste esta línea en el archivo:

bash
Copiar código
export KUBECONFIG=/etc/kubernetes/admin.conf
Guarda y cierra el archivo. Ahora recarga la configuración:

bash
Copiar código
source /root/.bashrc
2. Evitar el uso de sudo en source
No necesitas usar sudo para ejecutar source. El comando source carga el archivo en el contexto actual del shell, y no puede ejecutarse con sudo. Simplemente usa:

bash
Copiar código
source ~/.bashrc
3. Verificar permisos y propiedades
Para asegurarte de que el archivo /etc/kubernetes/admin.conf es accesible, ajusta los permisos y la propiedad como se mostró antes:

bash
Copiar código
sudo chmod 600 /etc/kubernetes/admin.conf
sudo chown root:root /etc/kubernetes/admin.conf
4. Verificar persistencia tras reiniciar
Si los cambios aún no persisten después de reiniciar, asegúrate de que el archivo .bashrc o .bash_profile esté configurado correctamente para ejecutarse en cada inicio de sesión.

4.1. Verificar .bash_profile
Si los cambios en .bashrc no tienen efecto, edita también el archivo .bash_profile para asegurar que se cargue correctamente en el inicio de sesión:

bash
Copiar código
sudo vim /root/.bash_profile
Asegúrate de que el archivo incluya lo siguiente:

bash
Copiar código
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
Esto asegura que el archivo .bashrc se cargue en cada inicio de sesión.

5. Prueba final
Después de hacer estos cambios, reinicia el sistema para asegurarte de que el archivo admin.conf se cargue correctamente y no tengas que especificarlo manualmente cada vez que ejecutes oc.

bash
Copiar código
sudo reboot
Tras el reinicio, prueba:

bash
Copiar código
oc get nodes
Esto debería funcionar sin tener que especificar manualmente --kubeconfig.