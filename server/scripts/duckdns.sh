#!/usr/bin/env bash
# Atualiza o IP no DuckDNS e avisa quando a atualização falha.
# Cron: */5 * * * * /opt/infradev-remote/server/scripts/duckdns.sh
set -u
. "$(dirname "$0")/common.sh"

if [ -z "${DUCKDNS_DOMAIN:-}" ] || [ -z "${DUCKDNS_TOKEN:-}" ]; then
  avisar "DUCKDNS_DOMAIN ou DUCKDNS_TOKEN faltando no .env; DNS não foi atualizado"
  exit 1
fi

resposta=$(curl -fsS -m 30 "https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip=" 2>&1)
estado="$SERVER_DIR/.duckdns-falhou"
if [ "$resposta" = "OK" ]; then
  [ -f "$estado" ] && rm -f "$estado" && avisar "DuckDNS voltou a atualizar normalmente"
  exit 0
fi
# Avisa só na primeira falha seguida, para não mandar mensagem a cada 5 minutos.
if [ ! -f "$estado" ]; then
  touch "$estado"
  avisar "DuckDNS não atualizou (resposta: ${resposta:-vazia}). Confira domínio e token no .env"
fi
exit 1
