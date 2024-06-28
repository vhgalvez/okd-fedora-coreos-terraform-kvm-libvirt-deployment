Resolución de Problemas de DNS Externa en FreeIPA

Este documento proporciona una guía detallada para solucionar problemas de resolución de DNS externa en un servidor FreeIPA, específicamente deshabilitando la validación DNSSEC.

Paso 1: Verificar y Configurar DNSSEC
Editar el Archivo de Configuración de named
Primero, necesitamos editar el archivo de configuración de named para deshabilitar DNSSEC.

bash
Copiar código
sudo vi /etc/named/ipa-options-ext.conf
Deshabilitar DNSSEC
Asegúrate de que la opción dnssec-validation esté configurada en no. Añade o edita las siguientes líneas en el bloque options:

conf
Copiar código
/* User customization for BIND named
 *
 * This file is included in /etc/named.conf and is not modified during IPA
 * upgrades.
 *
 * It must only contain "options" settings. Any other setting must be
 * configured in /etc/named/ipa-ext.conf.
 *
 * Examples:
 * allow-recursion { trusted_network; };
 * allow-query-cache { trusted_network; };
 */

/* turns on IPv6 for port 53, IPv4 is on by default for all ifaces */
listen-on-v6 { any; };

/* dnssec-enable is obsolete and 'yes' by default */

dnssec-validation no;
Reiniciar el Servicio named
Guarda los cambios y reinicia el servicio DNS para aplicar los cambios.

bash
Copiar código
sudo systemctl restart named
Si encuentras un error, verifica el estado del servicio y los logs para más detalles:

bash
Copiar código
sudo systemctl status named
journalctl -xeu named.service
Paso 2: Verificar la Resolución de DNS
Verificar la Resolución de un Dominio Externo
Usa el comando dig para comprobar si ahora puedes resolver dominios externos.

bash
Copiar código
dig google.com
Paso 3: Limpiar la Caché de DNS (Opcional)
Limpiar la Caché de DNS
Aunque el servicio named reiniciado debería limpiar la caché, puedes hacerlo manualmente si es necesario.

bash
Copiar código
sudo rndc flush
Paso 4: Verificar la Configuración de Firewall
Asegúrate de que el Firewall no esté Bloqueando las Solicitudes DNS
Listar las Reglas del Firewall
Verifica las reglas actuales del firewall.

bash
Copiar código
sudo firewall-cmd --list-all
Permitir el Tráfico DNS si es Necesario
Si ves que las reglas del firewall están bloqueando el puerto 53, añade las reglas necesarias para permitir el tráfico DNS.

bash
Copiar código
sudo firewall-cmd --permanent --add-port=53/udp
sudo firewall-cmd --permanent --add-port=53/tcp
sudo firewall-cmd --reload
Paso 5: Verificar la Conectividad de Red
Verificar la Conectividad Hacia el Reenviador DNS
Asegúrate de que tu servidor pueda alcanzar el reenviador DNS configurado (8.8.8.8).

bash
Copiar código
ping 8.8.8.8
Resumen
Editar /etc/named/ipa-options-ext.conf:

Añade dnssec-validation no; al bloque de opciones.
Reiniciar el Servicio named:

Reinicia el servicio DNS para aplicar los cambios.
Verificar los Reenviadores DNS:

Asegúrate de que los reenviadores estén correctamente configurados.
Probar la Resolución DNS:

Usa dig para confirmar que la resolución de DNS externa está funcionando.
Verificar la Configuración de Firewall:

Asegúrate de que el firewall permite el tráfico DNS en el puerto 53.
Verificar la Conectividad de Red:

Confirma que tu servidor puede alcanzar el reenviador DNS.
Siguiendo estos pasos, deberías poder resolver tanto nombres de dominio internos como externos utilizando tu servidor DNS de FreeIPA.

Ejemplo de Archivo de Configuración de named
A continuación se muestra un ejemplo del archivo de configuración de named:

conf
Copiar código
/* WARNING: This config file is managed by IPA.
 *
 * DO NOT MODIFY! Any modification will be overwritten by upgrades.
 *
 *
 * - /etc/named/ipa-options-ext.conf (for options)
 * - /etc/named/ipa-logging-ext.conf (for logging options)
 * - /etc/named/ipa-ext.conf (all other settings)
 */

options {
        // Put files that named is allowed to write in the data/ directory:
        directory "/var/named"; // the default
        dump-file               "data/cache_dump.db";
        statistics-file         "data/named_stats.txt";
        memstatistics-file      "data/named_mem_stats.txt";

        tkey-gssapi-keytab "/etc/named.keytab";

        pid-file "/run/named/named.pid";

        managed-keys-directory "/var/named/dynamic";

        /* user customizations of options */
        include "/etc/named/ipa-options-ext.conf";

        /* crypto policy snippet on platforms with system-wide policy. */
        include "/etc/crypto-policies/back-ends/bind.config";
};

/* If you want to enable debugging, eg. using the 'rndc trace' command,
 * By default, SELinux policy does not allow named to modify the /var/named directory,
 * so put the default debug log file in data/ :
 */
logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
                print-time yes;
        };
        include "/etc/named/ipa-logging-ext.conf";
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

/* user customization */
include "/etc/named/ipa-ext.conf";

dyndb "ipa" "/usr/lib64/bind/ldap.so" {
        uri "ldapi://%2fvar%2frun%2fslapd-CEFASLOCALSERVER-COM.socket";
        base "cn=dns,dc=cefaslocalserver,dc=com";
        server_id "freeipa1.cefaslocalserver.com";
        auth_method "sasl";
        sasl_mech "EXTERNAL";
        krb5_keytab "FILE:/etc/named.keytab";
};