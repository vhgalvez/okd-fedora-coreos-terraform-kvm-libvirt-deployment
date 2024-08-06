

```bash
ipa dnsrecord-add cefaslocalserver.com bootstrap --a-rec 10.17.4.27
ipa dnsrecord-add cefaslocalserver.com helper --a-rec 10.17.3.14
ipa dnsrecord-add cefaslocalserver.com master1 --a-rec 10.17.4.21
ipa dnsrecord-add cefaslocalserver.com master2 --a-rec 10.17.4.22
ipa dnsrecord-add cefaslocalserver.com master3 --a-rec 10.17.4.23
ipa dnsrecord-add cefaslocalserver.com worker1 --a-rec 10.17.4.24
ipa dnsrecord-add cefaslocalserver.com worker2 --a-rec 10.17.4.25
ipa dnsrecord-add cefaslocalserver.com worker3 --a-rec 10.17.4.26
ipa dnsrecord-add cefaslocalserver.com bastion1 --a-rec 192.168.0.20
ipa dnsrecord-add cefaslocalserver.com freeipa1 --a-rec 10.17.3.11
ipa dnsrecord-add cefaslocalserver.com load_balancer1 --a-rec 10.17.3.12
ipa dnsrecord-add cefaslocalserver.com postgresql1 --a-rec 10.17.3.1
```


