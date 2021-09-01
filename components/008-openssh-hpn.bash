#!/usr/bin/env bash

set -ex

yay -S openssh-hpn --noconfirm --removemake --needed

sudo systemctl enable --now sshd
