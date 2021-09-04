#!/usr/bin/env bash

set -ex

yay -S borg --noconfirm --removemake --needed

cat <<EOF | sudo tee /etc/systemd/system/borg.service > /dev/null
[Unit]
Description=borgbackup server
Wants=sshd.service
After=sshd.service
After=network.target
After=getty.service

[Service]
ExecStart=/usr/bin/borg serve
StandardInput=tty
Type=simple
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now borg.service
