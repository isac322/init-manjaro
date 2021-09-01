#!/usr/bin/env bash

set -ex

yay -S openssh --noconfirm --removemake --needed

sudo systemctl enable --now sshd
