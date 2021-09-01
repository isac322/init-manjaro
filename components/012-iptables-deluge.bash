#!/usr/bin/env bash

set -ex

iptables -A TCP -p tcp --dport 58846 -j ACCEPT
iptables -A TCP -p tcp --dport 56881:56889 -j ACCEPT

iptables -A UDP -p udp --dport 56881:56889 -j ACCEPT
