#!/usr/bin/env bash

set -ex

sudo pacman-mirrors --api --set-branch testing
sudo pacman -Sy --noconfirm
