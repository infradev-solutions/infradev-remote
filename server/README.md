# Servidor InfraDev Remote

Passo a passo completo, partindo de um **Ubuntu Server recém-instalado**, acessado só por SSH.
Siga na ordem. Os comandos são para Ubuntu 22.04 ou 24.04.

O servidor não usa as portas 80 nem 443, só de 21114 a 21119.

---

## 1. Entrar no servidor

Do seu computador:

```bash
ssh SEU_USUARIO@IP_DO_SERVIDOR
```

## 2. Atualizar o sistema e acertar o fuso horário

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y git curl ca-certificates
sudo timedatectl set-timezone America/Sao_Paulo
sudo reboot
```

Espere um minuto e entre de novo por SSH.

## 3. Fixar o IP do servidor na rede local

O MikroTik vai mandar o tráfego para um IP fixo, então ele não pode mudar.
Escolha **uma** das opções.

**Opção A (mais simples): reservar o IP no MikroTik.** No terminal do MikroTik:

```
/ip dhcp-server lease print where host-name~"NOME_DO_SERVIDOR"
/ip dhcp-server lease make-static [find where host-name~"NOME_DO_SERVIDOR"]
```

**Opção B: IP fixo no próprio Ubuntu.** Veja o nome da placa de rede:

```bash
ip -br a
```

Crie o arquivo (troque `enp1s0`, os IPs e o gateway pelos seus):

```bash
sudo tee /etc/netplan/60-ip-fixo.yaml > /dev/null <<'EOF'
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: false
      addresses: [192.168.88.10/24]
      routes:
        - to: default
          via: 192.168.88.1
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
EOF
sudo chmod 600 /etc/netplan/60-ip-fixo.yaml
sudo netplan try
```

O `netplan try` aplica e desfaz sozinho em 120 segundos se você não confirmar.
Se a conexão SSH cair, entre de novo pelo IP novo e aperte Enter para confirmar.

## 4. Liberar as portas no firewall do Ubuntu

```bash
sudo ufw allow OpenSSH
sudo ufw allow 21114:21119/tcp
sudo ufw allow 21116/udp
sudo ufw enable
sudo ufw status
```

Confira se a linha `OpenSSH` aparece como `ALLOW` antes de sair, para não perder o acesso.

## 5. Instalar o Docker

```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

Saia (`exit`) e entre de novo por SSH para o seu usuário poder usar o Docker sem `sudo`.
Para conferir:

```bash
docker run --rm hello-world
```

## 6. Baixar o InfraDev Remote

```bash
sudo mkdir -p /opt/infradev-remote
sudo chown $USER:$USER /opt/infradev-remote
git clone https://github.com/infradev-solutions/infradev-remote.git /opt/infradev-remote
cd /opt/infradev-remote/server
cp .env.example .env
```

O `.env` já vem com `PUBLIC_HOST=remote.infradevsolutions.com.br`. Só mude se for usar outro endereço.

## 7. Subir o servidor

```bash
cd /opt/infradev-remote/server
docker compose up -d
docker compose ps
```

Os três serviços (`hbbs`, `hbbr` e `api`) devem aparecer como `running`.
Eles voltam sozinhos se o servidor reiniciar.

Para ver se as portas estão abertas:

```bash
sudo ss -tulpn | grep 2111
```

## 8. Pegar a chave pública

```bash
cat /opt/infradev-remote/server/data/id_ed25519.pub
```

Esse texto é a chave **pública**. Ela vai embutida no app e pode ser compartilhada.
**Nunca compartilhe `data/id_ed25519`** (sem o `.pub`), que é a chave privada.
O servidor só aceita apps com a sua chave, então ninguém de fora consegue usá-lo.

## 9. Primeiro acesso ao painel e ao catálogo

Pegue a senha inicial do usuário `admin`:

```bash
docker compose logs api | grep -i password
```

Abra `http://IP_DO_SERVIDOR:21114/_admin/` no navegador da sua rede, entre como `admin` e **troque a senha**.
Depois que o DNS e as portas estiverem prontos, o endereço externo é
`http://remote.infradevsolutions.com.br:21114/_admin/`.

As sessões de acesso remoto são criptografadas de ponta a ponta em qualquer caso.
O painel começa em HTTP; colocar HTTPS numa porta alta é um próximo passo.

## 10. DNS e portas no roteador

1. DNS na HostGator: [docs/dns.md](../docs/dns.md)
2. Redirecionamento no MikroTik: [docs/mikrotik.md](../docs/mikrotik.md)

Para testar de fora da sua rede (por exemplo, de um notebook no 4G do celular):

```bash
nc -vz remote.infradevsolutions.com.br 21116
```

---

## Manutenção

**Atualizar o servidor:**

```bash
cd /opt/infradev-remote && git pull
cd server && docker compose pull && docker compose up -d
```

**Backup** (chaves e catálogo; guarde fora do servidor):

```bash
cd /opt/infradev-remote/server
sudo tar czf ~/backup-infradev-remote-$(date +%F).tar.gz data api-data
```

Se você perder a pasta `data`, o servidor gera uma chave nova e todos os apps instalados param de conectar.

**Ver logs:**

```bash
cd /opt/infradev-remote/server && docker compose logs -f --tail 50
```

## Referência: portas

| Porta | Protocolo | Para quê |
|---|---|---|
| 21114 | TCP | Painel web e catálogo de endereços |
| 21115 | TCP | Teste de tipo de NAT |
| 21116 | TCP e UDP | Servidor de IDs (registro e encontro das máquinas) |
| 21117 | TCP | Relay (repasse da conexão) |
| 21118, 21119 | TCP | Acesso pelo navegador (opcional) |
