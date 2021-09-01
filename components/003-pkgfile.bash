#!/usr/bin/env bash

set -ex

sudo pacman -S pkgfile --noconfirm --asexplicit
sudo systemctl enable --now pkgfile-update.timer
