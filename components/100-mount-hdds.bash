#!/usr/bin/env bash

set -ex

yay -S jq --noconfirm --needed

PARTINFO=$(lsblk -I 8 -pnMJ -o NAME,TYPE,UUID,MOUNTPOINT,FSTYPE | jq -cr '.blockdevices | map(select(.type == "disk") | .children[]) | map(select(.mountpoint == null))')
mapfile -t uuids < <(jq -rn --argjson data "$PARTINFO" '$data | map(.uuid)[]')

for (( i = 0; i < ${#uuids[@]}; i++ )); do
  UUID="${uuids[$i]}"
  MOUNTPOINT="/mnt/data${i}"
  OPTIONS='defaults,noatime,noauto,x-systemd.automount'
  FSTYPE=$(jq -rn --argjson data "$PARTINFO" --arg uuid "$UUID" '$data[] | select(.uuid == $uuid) | .fstype')
  NAME=$(jq -rn --argjson data "$PARTINFO" --arg uuid "$UUID" '$data[] | select(.uuid == $uuid) | .name')

  sudo mkdir -p "$MOUNTPOINT"
  echo -e "\n# ${NAME}\nUUID=${UUID}\t${MOUNTPOINT}\t${FSTYPE}\t${OPTIONS}\t0\t2" | sudo tee -a /etc/fstab > /dev/null
done
