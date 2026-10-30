# DNS na HostGator

No cPanel da HostGator, abra **Zone Editor** (Editor de Zona) no domínio `infradevsolutions.com.br` e adicione:

| Tipo | Nome | Valor | TTL |
|---|---|---|---|
| A | `remote` | IP público fixo do seu link | 14400 |

Para conferir (pode levar alguns minutos):

```bash
nslookup remote.infradevsolutions.com.br
```

O resultado precisa ser o mesmo IP que aparece em https://meuip.com.br.
Se a operadora trocar o seu IP, basta atualizar esse registro.
