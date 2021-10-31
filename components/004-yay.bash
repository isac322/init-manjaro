#!/usr/bin/env bash

set -ex

linux_pkg=$(pacman -Qoq "/usr/lib/modules/$(uname -r)/kernel")
sudo pacman -Sy yay base-devel "${linux_pkg}-headers" --noconfirm --needed
