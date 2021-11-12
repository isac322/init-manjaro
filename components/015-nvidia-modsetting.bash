#!/usr/bin/env bash

set -ex

sudo sed -i -E 's/^MODULES=("|\()([^")]*)("|\))$/MODULES=(\2 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf

cat <<EOF | sudo tee /etc/modprobe.d/nvidia.conf >> /dev/null
options nvidia-drm modeset=1
options nvidia NVreg_UsePageAttributeTable=1
EOF

sudo mkinitcpio -P

sudo mkdir -p /etc/pacman.d/hooks/
cat <<EOF | sudo tee /etc/pacman.d/hooks/nvidia.hook >> /dev/null
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF


sudo mkdir -p /etc/udev/rules.d
cat <<EOF | sudo tee /etc/udev/rules.d/70-nvidia.rules >> /dev/null
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c0 -u"
EOF