#!/usr/bin/env bash

set -ex

sudo iptables-save -f /etc/iptables/iptables.rules
sudo systemctl enable --now iptables