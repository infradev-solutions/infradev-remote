# Caddy com o plugin do DuckDNS, para tirar o certificado Let's Encrypt por DNS (sem as portas 80/443).
FROM caddy:2.11.9-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/duckdns

FROM caddy:2.11.9
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
