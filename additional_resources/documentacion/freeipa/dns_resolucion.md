# Registros DNS de nodos principales

# Nodo Bootstrap
ipa dnsrecord-add cefaslocalserver.com bootstrap --a-rec 10.17.3.21

# Nodo Helper
ipa dnsrecord-add cefaslocalserver.com helper --a-rec 10.17.3.14

# Nodos de Control Plane
ipa dnsrecord-add cefaslocalserver.com controlplane1 --a-rec 10.17.3.22
ipa dnsrecord-add cefaslocalserver.com controlplane2 --a-rec 10.17.3.23
ipa dnsrecord-add cefaslocalserver.com controlplane3 --a-rec 10.17.3.24

# Nodos de Worker
ipa dnsrecord-add cefaslocalserver.com worker1 --a-rec 10.17.3.25
ipa dnsrecord-add cefaslocalserver.com worker2 --a-rec 10.17.3.26
ipa dnsrecord-add cefaslocalserver.com worker3 --a-rec 10.17.3.27

# Nodo Bastion
ipa dnsrecord-add cefaslocalserver.com bastion1 --a-rec 192.168.0.20

# Nodo FreeIPA (Servidor DNS)
ipa dnsrecord-add cefaslocalserver.com freeipa1 --a-rec 10.17.3.11

# Balanceador de Carga
ipa dnsrecord-add cefaslocalserver.com load_balancer1 --a-rec 10.17.3.12

# Servidor PostgreSQL
ipa dnsrecord-add cefaslocalserver.com postgresql1 --a-rec 10.17.3.13

# Registros DNS para servicios de OpenShift

# API de OpenShift
ipa dnsrecord-add cefaslocalserver.com api.local --a-rec 10.17.3.22
ipa dnsrecord-add cefaslocalserver.com api.local --a-rec 10.17.3.23
ipa dnsrecord-add cefaslocalserver.com api.local --a-rec 10.17.3.24

# API Interna de OpenShift
ipa dnsrecord-add cefaslocalserver.com api-int.local --a-rec 10.17.3.22
ipa dnsrecord-add cefaslocalserver.com api-int.local --a-rec 10.17.3.23
ipa dnsrecord-add cefaslocalserver.com api-int.local --a-rec 10.17.3.24

# OAuth OpenShift
ipa dnsrecord-add cefaslocalserver.com oauth-openshift.apps.local --a-rec 10.17.3.22

# Consola de OpenShift
ipa dnsrecord-add cefaslocalserver.com console-openshift-console.apps.local --a-rec 10.17.3.22

# Cluster de Etcd
ipa dnsrecord-add cefaslocalserver.com etcd-0.local --a-rec 10.17.3.22
ipa dnsrecord-add cefaslocalserver.com etcd-1.local --a-rec 10.17.3.23
ipa dnsrecord-add cefaslocalserver.com etcd-2.local --a-rec 10.17.3.24
