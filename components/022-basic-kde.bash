#!/usr/bin/env bash

set -ex

yay -S bluedevil kcalc gwenview kdeconnect kio-gdrive korganizer kdepim-addons ark kcharselect kdenetwork-filesharing \
    kdesdk-kioslaves kdesdk-thumbnailers kgpg kipi-plugins kompare ksystemlog kwrite okular partitionmanager \
    print-manager spectacle sweeper yakuake latte-dock dolphin-plugins kscreen sddm-kcm ksshaskpass kamoso \
    kde-gtk-config gnome-settings-daemon gsettings-desktop-schemas gsettings-qt \
    kwalletcli \
    bluez-utils \
    baloo \
    nimf-libhangul-git \
    plasma-pa \
    plasma-simplemenu plasma5-applets-virtual-desktop-bar-git \
    caffeine-ng \
    xsettingsd \
    --noconfirm --removemake --needed

yes | yay -S pulseaudio-modules-bt libldac --removemake --norebuild --nodiffmenu --noeditmenu --noprovides --rebuildall

cat <<EOF > ~/.config/systemd/user/mpris-proxy.service
[Unit]
Description=Forward bluetooth media controls to MPRIS

[Service]
Type=simple
ExecStart=/usr/bin/mpris-proxy

[Install]
WantedBy=default.target
EOF

cat <<EOF > ~/.xsettingsd
Xft/Hinting 1
Xft/HintStyle "hintslight"
Xft/Antialias 1
Xft/RGBA "rgb"
EOF

systemctl --user enable --now xsettingsd mpris-proxy

cat <<EOF | sudo tee -a /etc/pulse/default.pa > /dev/null

### Automatically switch to newly-connected devices
load-module module-switch-on-connect
EOF

echo 'PINENTRY=pinentry-qt' > ~/.config/environment.d/99-default-pinentry.conf
echo 'pinentry-program /usr/bin/pinentry-kwallet' > ~/.gnupg/gpg-agent.conf
