#!/usr/bin/env bash

set -ex

yay -S sshguard --noconfirm --removemake --needed

cat <<EOF | sudo tee /etc/sshguard.conf
# Full path to backend executable (required, no default)
BACKEND="/usr/lib/sshguard/sshg-fw-iptables"

# Log reader command (optional, no default)
LOGREADER="LANG=C /usr/bin/journalctl -afb -p info -n1 -t sshd -o cat"

# How many problematic attempts trigger a block
THRESHOLD=20
# Blocks last at least 180 seconds
BLOCK_TIME=180
# The attackers are remembered for up to 3600 seconds
DETECTION_TIME=3600

# Blacklist threshold and file name
BLACKLIST_FILE=100:/var/db/sshguard/blacklist.db

# IPv6 subnet size to block. Defaults to a single address, CIDR notation. (optional, default to 128)
IPV6_SUBNET=64
# IPv4 subnet size to block. Defaults to a single address, CIDR notation. (optional, default to 32)
IPV4_SUBNET=24
EOF

sudo systemctl enable --now sshguard
