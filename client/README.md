# App InfraDev Remote

## Plano

O app é uma versão personalizada do RustDesk (AGPL-3.0), num fork separado:
`infradev-solutions/infradev-remote-client`.

No fork, aplicamos:
1. Nome **InfraDev Remote**, ícone e cores da InfraDev.
2. Servidor `remote.infradevsolutions.com.br`, chave pública e API do catálogo já embutidos
   (variáveis `RENDEZVOUS_SERVER`, `RS_PUB_KEY` e `API_SERVER`, guardadas como *secrets* do GitHub).
3. Builds automáticos no GitHub Actions para Windows, macOS, Linux e Android.
   iOS sai como app só de controle (a Apple não permite que um iPhone seja controlado).

Assim, o cliente só instala, abre e te passa o ID. Nada para configurar.

## Enquanto o app personalizado não fica pronto

Já dá para usar o RustDesk oficial apontando para o seu servidor:

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
