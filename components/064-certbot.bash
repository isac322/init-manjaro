#!/usr/bin/env bash

set -ex

yay -S certbot-dns-cloudflare --noconfirm --removemake --needed

read -r -p 'Cloudflare API Token: ' cf_token

echo -n "dns_cloudflare_api_token = ${cf_token}" | sudo tee /etc/letsencrypt/.cf_key > /dev/null
sudo chmod 400 /etc/letsencrypt/.cf_key

read -r -p 'Domain to get cert: ' domain_name
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/.cf_key -d "$domain_name" --agree-tos

cat <<EOF | sudo tee /etc/systemd/system/certbot.service > /dev/null
[Unit]
Description=Let's Encrypt renewal

[Service]
Type=oneshot
ExecStart=/usr/bin/certbot renew --quiet --agree-tos
EOF

cat <<EOF | sudo tee /etc/systemd/system/certbot.timer > /dev/null
[Unit]
[Unit]
Description=Twice daily renewal of Let's Encrypt's certificates

[Timer]
OnCalendar=0/12:00:00
RandomizedDelaySec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl enable --now certbot.timer
