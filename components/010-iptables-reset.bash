#!/usr/bin/env bash

function rm_pkg() {
    if pacman -Qi "$@" &> /dev/null; then
        sudo pacman -Rns "$@" --noconfirm
    fi
}

set -ex

rm_pkg iptables
yes | yay -S iptables-nft --needed

sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -t raw -F
sudo iptables -t raw -X
sudo iptables -t security -F
sudo iptables -t security -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
