# InfraDev Remote

Acesso remoto da InfraDev Solutions, no estilo AnyDesk, gratuito e com servidor próprio.

- **Plataformas:** Windows, macOS, Linux, Android (controlar e ser controlado) e iOS (só controlar).
- **Servidor próprio:** `remote.infradevsolutions.com.br`, nada passa por terceiros.
- **Catálogo de endereços:** máquinas cadastradas e sincronizadas entre os seus aparelhos.

## Como funciona

```
 [Seu PC / celular] ──┐                        ┌── [Máquina do cliente]
                      ├── remote.infradev... ──┤
                      │   (IDs, relay, catálogo)│
                      └──── conexão direta ─────┘   (quando a rede permite)
```

| Pasta | Conteúdo |
|---|---|
| [server/](server/) | Servidor (Docker): IDs, relay, painel e catálogo |
| [client/](client/) | Plano do app personalizado e uso imediato com o RustDesk oficial |
| [docs/](docs/) | DNS na HostGator e redirecionamento de portas no MikroTik |

## Ordem de implantação

1. DNS: [docs/dns.md](docs/dns.md)
2. Portas no MikroTik: [docs/mikrotik.md](docs/mikrotik.md)
3. Servidor: [server/README.md](server/README.md)
4. App: [client/README.md](client/README.md)

## Licença

Baseado no [RustDesk](https://github.com/rustdesk/rustdesk) e no
[rustdesk-api](https://github.com/lejianwen/rustdesk-api). O app modificado segue a AGPL-3.0,
por isso o código fica público.
