#!/usr/bin/env bash
# Backup diário das chaves (data/) e do catálogo (api-data/).
# Guarda BACKUP_KEEP_DAYS dias em BACKUP_DIR e, se RCLONE_REMOTE estiver no .env, copia para fora.
# Cron: 30 3 * * * /opt/infradev-remote/server/scripts/backup.sh
set -u
. "$(dirname "$0")/common.sh"
cd "$SERVER_DIR" || exit 1

destino="${BACKUP_DIR:-$HOME/backups-infradev-remote}"
mkdir -p "$destino"
arquivo="$destino/infradev-remote-$(date +%F).tar.gz"

# Para o painel por alguns segundos para o banco do catálogo não ser copiado no meio de uma escrita.
# IDs e relay continuam funcionando.
docker compose stop api > /dev/null 2>&1
tar czf "$arquivo" data api-data
ok=$?
docker compose start api > /dev/null 2>&1

if [ $ok -ne 0 ]; then
  avisar "backup falhou ao criar $arquivo"
  exit 1
fi
chmod 600 "$arquivo"
find "$destino" -name 'infradev-remote-*.tar.gz' -mtime +"${BACKUP_KEEP_DAYS:-14}" -delete

if [ -n "${RCLONE_REMOTE:-}" ]; then
  if ! rclone copy "$arquivo" "$RCLONE_REMOTE" 2>/dev/null; then
    avisar "backup criado, mas a cópia para $RCLONE_REMOTE falhou"
    exit 1
  fi
fi
