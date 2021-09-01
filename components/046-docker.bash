#!/usr/bin/env bash

set -ex

yay -S docker-compose docker --noconfirm --removemake --needed

sudo mkdir -p /etc/systemd/system/docker.service.d

cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/override.conf > /dev/null
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now docker
