#!/usr/bin/env bash

set -ex

yay -S docker-compose docker --noconfirm --removemake --needed

sudo mkdir -p /etc/systemd/system/docker.service.d

cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/override.conf > /dev/null
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
	hosts: [fd://, tcp://127.0.0.1:2375]
}
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now docker
