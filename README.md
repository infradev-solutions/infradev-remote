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

1. Servidor, do Ubuntu recém-instalado até o painel no ar: [server/README.md](server/README.md)
   (inclui DNS na HostGator e portas no MikroTik)
2. App: [client/README.md](client/README.md)

## Licença

Baseado no [RustDesk](https://github.com/rustdesk/rustdesk) e no
[rustdesk-api](https://github.com/lejianwen/rustdesk-api). O app modificado segue a AGPL-3.0,
por isso o código fica público.
