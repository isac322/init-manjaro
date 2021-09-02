#!/usr/bin/env bash

set -ex

if pacman -Qi exfat-utils &> /dev/null; then
  sudo pacman -Rns exfat-utils --noconfirm
fi
yay -S exfatprogs --noconfirm --removemake --needed