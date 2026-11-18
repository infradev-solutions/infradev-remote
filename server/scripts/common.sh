# Funções usadas pelos scripts do servidor. Carrega o .env da pasta server/.
SERVER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
[ -f "$SERVER_DIR/.env" ] && . "$SERVER_DIR/.env"

# Manda um aviso no Telegram (se TELEGRAM_BOT_TOKEN e TELEGRAM_CHAT_ID estiverem no .env)
# e grava no log do sistema. Uso: avisar "mensagem"
avisar() {
  logger -t infradev-remote "$1"
  if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ]; then
    curl -fsS -m 20 "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
      --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
      --data-urlencode "text=InfraDev Remote: $1" > /dev/null \
      || logger -t infradev-remote "falha ao enviar aviso no Telegram"
  fi
}
