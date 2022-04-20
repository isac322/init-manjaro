#!/usr/bin/env bash

set -x

mapfile -t hdds < <(lsblk -I 8 -pnd --output NAME)

# https://wiki.archlinux.org/title/hdparm#Power_management_configuration
for hdd in "${hdds[@]}" ; do
  sudo hdparm -B 127 "$hdd"
  sudo hdparm -S 120 "$hdd"
  sudo hdparm -M 180 "$hdd"
done