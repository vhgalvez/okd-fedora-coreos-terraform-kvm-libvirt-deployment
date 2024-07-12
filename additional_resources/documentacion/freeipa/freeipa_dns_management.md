# Documentación: Cómo Eliminar y Agregar un Registro DNS en FreeIPA

Esta guía te mostrará cómo eliminar un registro DNS incorrecto y luego agregar un registro DNS correcto en FreeIPA. Asegúrate de tener permisos de administrador y de haber iniciado sesión en el servidor FreeIPA.

## Paso 1: Obtener un Ticket de Kerberos

Antes de realizar cualquier operación, obtén un ticket de Kerberos para el usuario administrador:

```bash
kinit admin
```

Introduce la contraseña del usuario admin cuando se te pida.

Paso 2: Eliminar un Registro DNS
Para eliminar un registro DNS incorrecto, utiliza el comando ipa dnsrecord-del.

Sintaxis del Comando
bash
Copiar código
ipa dnsrecord-del <dominio> <nombre> --a-rec <dirección IP>
Ejemplo
Para eliminar el registro bootstrap1 con la dirección IP incorrecta 10.17.4.20:

bash
Copiar código
ipa dnsrecord-del cefaslocalserver.com bootstrap1 --a-rec 10.17.4.20
Paso 3: Agregar un Registro DNS
Para agregar un registro DNS correcto, utiliza el comando ipa dnsrecord-add.

Sintaxis del Comando
bash
Copiar código
ipa dnsrecord-add <dominio> <nombre> --a-rec <dirección IP>
Ejemplo
Para agregar el registro bootstrap1 con la dirección IP correcta 10.17.3.14:

bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com bootstrap1 --a-rec 10.17.3.14
Ejemplo Completo
A continuación se muestra un ejemplo completo del proceso para eliminar y agregar un registro DNS:

Obtener un ticket de Kerberos:
bash
Copiar código
kinit admin
Eliminar el registro DNS incorrecto:
bash
Copiar código
ipa dnsrecord-del cefaslocalserver.com bootstrap1 --a-rec 10.17.4.20
Agregar el registro DNS correcto:
bash
Copiar código
ipa dnsrecord-add cefaslocalserver.com bootstrap1 --a-rec 10.17.3.14
Verificar los Registros DNS
Para verificar que el registro se ha agregado correctamente, utiliza el comando ipa dnsrecord-find:

bash
Copiar código
ipa dnsrecord-find cefaslocalserver.com
Notas Finales
Asegúrate de que tu ticket de Kerberos esté vigente antes de realizar operaciones en FreeIPA.
Verifica siempre los registros DNS después de realizar cambios para asegurar que se han aplicado correctamente.