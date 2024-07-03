Parece que tu servidor DNS en FreeIPA está funcionando correctamente tanto para las consultas internas como externas, como se muestra en las respuestas de dig. Aquí hay una guía rápida para verificar y agregar más registros DNS si es necesario.

Verificación de Registros DNS
Revisar la configuración de DNS en las máquinas virtuales:

Verifica el contenido de /etc/resolv.conf para asegurarte de que apunta al servidor DNS correcto.
bash
Copiar código
cat /etc/resolv.conf
Asegúrate de que incluya nameserver 10.17.3.11.

Comprobar la resolución de nombres:

Usa dig para verificar la resolución de nombres para varios registros.
bash
Copiar código
dig bootstrap1.cefaslocalserver.com
dig master1.cefaslocalserver.com
dig google.com
Si las consultas devuelven las direcciones IP correctas, significa que la resolución DNS está funcionando bien.

Agregar y Verificar Registros DNS
Agregar un nuevo registro DNS:

Utiliza el comando ipa dnsrecord-add para agregar nuevos registros.
bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com newhost --a-rec 192.168.0.22
Verificar los registros DNS existentes:

Puedes listar todos los registros DNS usando ipa dnsrecord-find.
bash
Copiar código
ipa dnsrecord-find cefaslocalserver.com
Esto mostrará todos los registros actuales para el dominio cefaslocalserver.com.

Verificación en una Máquina Virtual
Comprobar la resolución de DNS:
Ejecuta dig para consultar tanto nombres internos como externos desde la máquina virtual.

bash
Copiar código
dig bootstrap1.cefaslocalserver.com
dig master1.cefaslocalserver.com
dig google.com
Ping a un nombre de dominio:
Comprueba la conectividad usando ping.

bash
Copiar código
ping bootstrap1.cefaslocalserver.com
ping google.com
Confirmar el Funcionamiento del DNS
Si todas las consultas dig y ping devuelven las respuestas correctas, puedes estar seguro de que tu configuración DNS está funcionando correctamente. Si encuentras algún problema, revisa los logs del servidor DNS y la configuración en /etc/named.conf y /etc/named/ipa-options-ext.conf.