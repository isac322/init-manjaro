#!/usr/bin/env bash

set -ex

sudo iptables -I INPUT -p tcp --dport 21 -j sshguard

sudo iptables -A TCP -p tcp --dport 21 -j ACCEPT
sudo iptables -A TCP -p tcp --dport 50000:51000 -j ACCEPT
