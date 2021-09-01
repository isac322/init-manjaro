#!/usr/bin/env bash

set -ex

sudo iptables -A TCP -p tcp --dport 58846 -j ACCEPT
sudo iptables -A TCP -p tcp --dport 56881:56889 -j ACCEPT

sudo iptables -A UDP -p udp --dport 56881:56889 -j ACCEPT
