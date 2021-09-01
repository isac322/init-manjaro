#!/usr/bin/env bash

set -ex

gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
yay -S 1password-cli jq --noconfirm --removemake --needed
