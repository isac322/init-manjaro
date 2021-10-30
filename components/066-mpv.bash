#!/usr/bin/env bash

set -ex

yay -S libplacebo rubberband uchardet luajit --noconfirm --removemake --asdeps --needed
yay -S mpv-git libchardet --noconfirm --removemake --needed
yay -S mpv-mpris --noconfirm --removemake --needed
yay -S mpv-git --noconfirm --removemake --rebuildall
