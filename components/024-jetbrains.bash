#!/usr/bin/env bash

set -ex

yay -S intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre clion clion-jre clion-cmake clion-gdb \
    --noconfirm --removemake --needed
