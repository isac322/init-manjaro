#!/usr/bin/env bash

set -ex

yay -S \
  ttf-apple-emoji \
  ttf-nanum nerd-fonts-jetbrains-mono noto-fonts-cjk-kr-vf \
  --noconfirm --removemake --needed
