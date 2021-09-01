#!/usr/bin/env bash

set -ex

function rm_pkg() {
    if pacman -Qi "$@" &> /dev/null; then
        sudo pacman -Rns "$@" --noconfirm
    fi
}

rm_pkg khelpcenter
rm_pkg kate
rm_pkg konversation
rm_pkg web-installer-url-handler pamac-tray-icon-plasma pamac-gtk manjaro-hello
rm_pkg manjaro-settings-manager-knotifier
rm_pkg manjaro-documentation-en
rm_pkg networkmanager-openconnect
rm_pkg kinfocenter
rm_pkg oxygen
rm_pkg firefox
rm_pkg pulseaudio-ctl
rm_pkg manjaro-settings-manager-kcm
rm_pkg matray
rm_pkg timeshift-autosnap-manjaro
rm_pkg manjaro-kde-settings

unset rm_pkg
