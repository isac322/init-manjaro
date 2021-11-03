#!/usr/bin/env bash

set -ex

# colorize pacman
sudo sed -i -E 's/#Color/Color/' /etc/pacman.conf

# optimize makepkg
sudo sed -i -E "s/^\s*(PKG|SRC)EXT\s*=\s*'(.+)\.(gz|xz|zst)'\s*$/\1EXT='\2'/" /etc/makepkg.conf

# SMP
sudo sed -i -E 's/#?\s*MAKEFLAGS=("|'\'')(.*)-j[0-9]*(\W+.*)?("|'\'')/MAKEFlAGS=\1\2-j$(nproc)\3\4/' /etc/makepkg.conf
