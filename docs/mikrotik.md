# Redirecionamento de portas no MikroTik

Troque `192.168.88.10` pelo IP do servidor na rede local e `192.168.88.0/24` pela sua rede local.
Cole no terminal do MikroTik (Winbox → New Terminal):

```
/ip firewall nat
add chain=dstnat dst-address-type=local protocol=tcp dst-port=21114-21119 action=dst-nat to-addresses=192.168.88.10 comment="InfraDev Remote TCP"
add chain=dstnat dst-address-type=local protocol=udp dst-port=21116 action=dst-nat to-addresses=192.168.88.10 comment="InfraDev Remote UDP"
add chain=srcnat src-address=192.168.88.0/24 dst-address=192.168.88.10 protocol=tcp dst-port=21114-21119 action=masquerade comment="InfraDev Remote hairpin TCP"
add chain=srcnat src-address=192.168.88.0/24 dst-address=192.168.88.10 protocol=udp dst-port=21116 action=masquerade comment="InfraDev Remote hairpin UDP"
```

- As duas primeiras regras levam o tráfego que chega da internet até o servidor.
- As duas últimas (hairpin) permitem usar `remote.infradevsolutions.com.br` de dentro da própria rede.
- `dst-address-type=local` funciona mesmo que o IP público mude.

## Se o seu firewall não for o padrão

A configuração padrão do MikroTik já deixa passar tráfego redirecionado.
Se você tiver regras próprias que bloqueiam o `forward`, adicione antes delas:

```
/ip firewall filter
add chain=forward connection-nat-state=dstnat action=accept comment="InfraDev Remote" place-before=0
```

## Conferir

```
/ip firewall nat print where comment~"InfraDev Remote"
```

De fora da rede (ex.: 4G do celular): `nc -vz remote.infradevsolutions.com.br 21116`.
