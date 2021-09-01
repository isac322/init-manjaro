#!/usr/bin/env bash

set -ex

iptables -I INPUT -m multiport -p tcp --dport 21 -j sshguard

iptables -A TCP -p tcp --dport 21 -j ACCEPT
iptables -A TCP -p tcp --dport 50000:51000 -j ACCEPT
