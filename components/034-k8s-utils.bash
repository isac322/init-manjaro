#!/usr/bin/env bash

set -ex

yay -S kubectl k9s helm stern-bin --noconfirm --removemake --needed
