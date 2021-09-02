#!/usr/bin/env bash

set -ex

if pacman -Qi ntfs-3g &> /dev/null; then
  sudo pacman -Rns ntfs-3g --noconfirm
fi
yay -S ntfs3-dkms --noconfirm --removemake --needed

cat <<EOF | sudo tee /etc/udev/rules.d/61-ntfs3-dkms.rules > /dev/null
SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="ntfs", ENV{ID_FS_TYPE}="ntfs3"
EOF

cat <<EOF | sudo tee /etc/udisks2/mount_options.conf > /dev/null
[defaults]
ntfs3_defaults=uid=\$UID,gid=\$GID
ntfs3_allow=uid=\$UID,gid=\$GID,umask,dmask,fmask,nls,nohidden,sys_immutable,discard,force,sparse,showmeta,prealloc,no_acs_rules,acl
EOF
