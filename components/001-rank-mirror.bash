#!/usr/bin/env bash

set -ex

sudo pacman-mirrors -c all
sudo pacman -Syu --noconfirm
