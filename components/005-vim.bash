#!/usr/bin/env bash

set -ex

yay -Q vi > /dev/null && yay -Rns vi --noconfirm

plugins=(
  vim
  vim-sensible-git
  vim-indentline-git
  vim-lastplace
  vim-syntastic
  vim-gitgutter
  vim-rust-git
  vim-editorconfig
  vim-supertab
  vim-colors-solarized-git
  vim-pkgbuild-git
  vim-airline
  typescript-vim-git
  vim-python-pep8-indent-git
  vim-csv-git
)
yay -S "${plugins[@]}" --noconfirm --removemake --needed
sudo sed -i -E 's/^\s*"\s*(let\s+skip_defaults_vim=1)\s*$/\1/' /etc/vimrc
