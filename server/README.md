# Servidor InfraDev Remote

Roda no servidor local da InfraDev (Linux com Docker). Não usa as portas 80 nem 443.

## Portas

| Porta | Protocolo | Para quê |
|---|---|---|
| 21114 | TCP | Painel web e catálogo de endereços |
| 21115 | TCP | Teste de tipo de NAT |
| 21116 | TCP e UDP | Servidor de IDs (registro e encontro das máquinas) |
| 21117 | TCP | Relay (repasse da conexão) |
| 21118, 21119 | TCP | Acesso pelo navegador (opcional) |

## Instalação

```bash
git clone https://github.com/infradev-solutions/infradev-remote.git
cd infradev-remote/server
cp .env.example .env
docker compose up -d
```

Na primeira execução o servidor gera um par de chaves em `data/`.
A chave pública fica em `data/id_ed25519.pub`; guarde o conteúdo, ele vai embutido no app.
**Nunca publique `data/id_ed25519`** (a chave privada). O `.gitignore` já impede isso.

Só aceita clientes com a sua chave (`-k _`), então ninguém de fora consegue usar o servidor.

## Painel e catálogo

Acesse `http://remote.infradevsolutions.com.br:21114/_admin/`.
A senha inicial do usuário `admin` aparece nos logs: `docker compose logs api | grep -i password`.
Troque essa senha no primeiro acesso.

As sessões de acesso remoto são criptografadas de ponta a ponta em qualquer caso.
O painel começa em HTTP; colocar HTTPS numa porta alta é um próximo passo.

Configuração de rede: [docs/mikrotik.md](../docs/mikrotik.md) e [docs/dns.md](../docs/dns.md).
