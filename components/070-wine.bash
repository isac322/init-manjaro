#!/usr/bin/env bash

set -ex

yay -S unzip-natspec --noconfirm --removemake --asdeps --needed

yay -S wine-staging winetricks wine-mono wine-gecko --noconfirm --removemake --asexplicit --needed

winetricks win7

cat <<EOF | tee /tmp/input-style-root.reg > /dev/null
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\X11 Driver]
"InputStyle"="root"
EOF

wine regedit /tmp/input-style-root.reg
