#!/usr/bin/env bash

set -ex

mkdir -p ~/.config/systemd/user
cat <<EOF > ~/.config/systemd/user/ssh-agent.service
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
# DISPLAY required for ssh-askpass to work
Environment=DISPLAY=:0
ExecStart=/usr/bin/ssh-agent -D -a \$SSH_AUTH_SOCK

[Install]
WantedBy=default.target
EOF

mkdir -p ~/.config/environment.d
echo 'SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"' > ~/.config/environment.d/99-ssh-agent.conf

mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/ssh-add.desktop
[Desktop Entry]
Exec=ssh-add -q
Name=ssh-add
Type=Application
EOF

mkdir -p ~/.config/plasma-workspace/env
cat <<EOF > ~/.config/plasma-workspace/env/askpass.sh
#!/bin/sh

export SSH_ASKPASS='/usr/bin/ksshaskpass'
EOF


chmod 700 ~/.config/autostart/ssh-add.desktop ~/.config/plasma-workspace/env/askpass.sh

systemctl --user enable --now ssh-agent
