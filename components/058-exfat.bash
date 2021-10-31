#!/usr/bin/env bash

set -ex

if [ $(pacman -Qq exfat-utils) = 'exfat-utils' ]; then
  sudo pacman -Rns exfat-utils --noconfirm
fi
yay -S exfatprogs --noconfirm --removemake --needed
