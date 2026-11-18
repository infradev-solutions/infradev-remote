# App InfraDev Remote

## Como o app é feito

O app é uma versão personalizada do RustDesk (AGPL-3.0), no fork
[`infradev-solutions/rustdesk`](https://github.com/infradev-solutions/rustdesk).

No fork, a pasta `infradev/` aplica a marca antes de cada build:
1. Nome **InfraDev Remote**, ícone e cores da InfraDev.
2. Servidor `remote.infradevsolutions.com.br`, chave pública e API do catálogo já embutidos
   (configurados em `infradev/branding.env`, aplicados por `infradev/apply-branding.sh`).
3. Builds no GitHub Actions (workflow **InfraDev build**, disparado à mão) para Windows, macOS, Linux e Android.
   Os instaladores saem na release [`instaladores`](https://github.com/infradev-solutions/infradev-remote/releases/tag/instaladores).
   iOS não é gerado (precisa de conta Apple Developer; e o iPhone só pode controlar, não ser controlado).

Assim, o cliente só instala, abre e te passa o ID. Nada para configurar.

## Usar o RustDesk oficial com o seu servidor

Se precisar, o RustDesk oficial também funciona apontando para o seu servidor:

- **Windows, sem configurar nada no cliente:** baixe o RustDesk oficial e renomeie o executável para
  `infradev-remote-host=remote.infradevsolutions.com.br,key=9dzORD6JxDS5qOC8omsYO2408R6o42+Hv0gHb0N9Dxg=,.exe`.
  Ele já abre ligado ao seu servidor.
- **Qualquer sistema:** Configurações → Rede → Servidor ID/Relay. Preencha:
  - Servidor de ID: `remote.infradevsolutions.com.br`
  - Servidor de relay: `remote.infradevsolutions.com.br`
  - Servidor de API: `http://remote.infradevsolutions.com.br:21114`
  - Chave: `9dzORD6JxDS5qOC8omsYO2408R6o42+Hv0gHb0N9Dxg=`

## Catálogo de endereços

No seu app (PC e celular), faça login com o usuário do painel. O catálogo
(máquinas, nomes, senhas, grupos por cliente) fica no servidor e sincroniza entre os seus aparelhos.
