#!/usr/bin/env bash

set -ex

yay -S kubectl k9s helm kubeseal stern-bin --noconfirm --removemake --needed
