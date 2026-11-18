# DNS na HostGator

O link da Vivo não tem IP fixo, então `remote.infradevsolutions.com.br` não aponta direto para um IP:
ele aponta (CNAME) para um nome do DuckDNS, que o servidor atualiza a cada 5 minutos
(`server/scripts/duckdns.sh`, ver [server/README.md](../server/README.md)).

No cPanel da HostGator, abra **Zone Editor** (Editor de Zona) no domínio `infradevsolutions.com.br`.
Apague o registro A antigo de `remote`, se existir, e adicione:

| Tipo | Nome | Valor | TTL |
|---|---|---|---|
| CNAME | `remote` | `remoteinfradev.duckdns.org` | 300 |

Para conferir (pode levar alguns minutos):

```bash
nslookup remote.infradevsolutions.com.br
```

O resultado precisa ser o mesmo IP que aparece em https://meuip.com.br.
Se não for, rode `server/scripts/duckdns.sh` no servidor: se ele avisar "KO", o domínio ou o token
do DuckDNS no `.env` estão errados.

Os apps instalados guardam só o nome, então trocar o IP nunca exige reinstalar nada.
