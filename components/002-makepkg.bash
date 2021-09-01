#!/usr/bin/env bash

set -ex

# colorize pacman
sudo sed -Ei 's/#Color/Color/' /etc/pacman.conf

# optimize makepkg
sudo sed -Ei "s/^\s*(PKG|SRC)EXT\s*=\s*'(.+)\.(gz|xz|zst)'\s*$/\1EXT='\2'/" /etc/makepkg.conf
