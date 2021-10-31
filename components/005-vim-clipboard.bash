#!/usr/bin/env bash

set -ex

yay -Q vi > /dev/null && yay -Rns vi --noconfirm

yay -S vim-clipboard --noconfirm --removemake --needed
plugins=(
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
)
yay -S "${plugins[@]}" --noconfirm --removemake --needed
yay -S vim-csv-git --noconfirm --removemake --needed
sudo sed -i -E 's/^\s*"\s*(let\s+skip_defaults_vim=1)\s*$/\1/' /etc/vimrc

echo -e '\nset clipboard=unnamedplus' | sudo tee -a /etc/vimrc > /dev/null

mkdir -p ~/.config/environment.d
echo 'EDITOR=vim' > ~/.config/environment.d/99-default-editor.conf
