# Resolución de Problemas de DNS Externa en FreeIPA

## Introducción

Esta guía detalla cómo solucionar problemas de resolución de DNS externa en FreeIPA, deshabilitando la validación DNSSEC.

## Paso 1: Verificar y Configurar DNSSEC

### Editar el Archivo de Configuración de named

```bash
sudo vi /etc/named/ipa-options-ext.conf
```

## Deshabilitar DNSSEC

Asegúrate de que la opción dnssec-validation esté configurada en no:


```bash
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
```

## Reiniciar el Servicio named

Guarda los cambios y reinicia el servicio DNS:

```bash
sudo systemctl restart named
```
Verificar el Estado del Servicio

```bash
sudo systemctl status named
journalctl -xeu named.service
```
## Paso 2: Verificar la Resolución de DNS

### Verificar la Resolución de DNS

```bash
dig google.com
```

## Paso 3: Limpiar la Caché de DNS (Opcional)

### Limpiar la Caché de DNS
        
```bash
sudo rndc flush
```

### Paso 4: Verificar la Configuración de Firewall

Listar las Reglas del Firewall

```bash
sudo firewall-cmd --list-all
```
### Permitir el Tráfico DNS si es Necesario


```bash
sudo firewall-cmd --permanent --add-port=53/udp
sudo firewall-cmd --permanent --add-port=53/tcp
sudo firewall-cmd --reload
```
### Paso 5: Verificar la Conectividad de Red

### Verificar la Conectividad Hacia el Reenviador DNS

```bash
ping 8.8.8.8
```

## Resumen

1. Editar `/etc/named/ipa-options-ext.conf`:
 
Añade `dnssec-validation no;` al bloque de opciones.

2. Reiniciar el servicio `named`:
        

```bash
sudo systemctl restart named
```

3. Verificar los Reenviadores DNS:

```bash
ipa dnsconfig-mod --forwarder=8.8.8.8
```

4. Probar la Resolución DNS:

```bash
dig google.com
```

5. Verificar la Configuración de Firewall:

```bash
sudo firewall-cmd --list-all
```

1. Verificar la Conectividad de Red:

```bash
ping 8.8.8.8
```

## Ejemplo de Archivo de Configuración de `named`

```bash
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
```