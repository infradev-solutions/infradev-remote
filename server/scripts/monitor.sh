#!/usr/bin/env bash
# Confere se os serviços estão de pé e se o DNS aponta para o IP atual. Avisa quando algo muda.
# Cron: */5 * * * * /opt/infradev-remote/server/scripts/monitor.sh
set -u
. "$(dirname "$0")/common.sh"
cd "$SERVER_DIR" || exit 1

problemas=()
for servico in hbbs hbbr api; do
  if [ -z "$(docker compose ps --status running -q "$servico" 2>/dev/null)" ]; then
    problemas+=("serviço $servico parado")
  fi
done

ip_atual=$(curl -fsS -m 20 https://api.ipify.org 2>/dev/null)
ip_dns=$(getent ahostsv4 "${PUBLIC_HOST:-}" 2>/dev/null | awk 'NR==1{print $1}')
if [ -z "$ip_atual" ]; then
  problemas+=("servidor sem internet (não descobriu o IP público)")
elif [ "$ip_atual" != "$ip_dns" ]; then
  problemas+=("${PUBLIC_HOST} aponta para ${ip_dns:-nada}, mas o IP atual é $ip_atual")
fi

# Só avisa quando a situação muda (problema novo ou tudo resolvido).
estado="$SERVER_DIR/.monitor-estado"
agora=$(printf '%s\n' "${problemas[@]}")
antes=$(cat "$estado" 2>/dev/null)
[ "$agora" = "$antes" ] && exit 0
printf '%s' "$agora" > "$estado"
if [ -z "$agora" ]; then
  avisar "tudo normal de novo"
else
  avisar "problema: $(printf '%s; ' "${problemas[@]}")"
fi
