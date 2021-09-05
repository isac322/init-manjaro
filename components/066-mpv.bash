#!/usr/bin/env bash

set -ex

yay -S libplacebo rubberband uchardet luajit --noconfirm --removemake --asdeps --needed
yay -S mpv-mpris libchardet --noconfirm --removemake --needed --assume-installed mpv
yay -S mpv-git --noconfirm --removemake --noconfirm --removemake --needed
