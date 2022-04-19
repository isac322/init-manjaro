#!/usr/bin/env bash

set -ex

sudo iptables -N TCP
sudo iptables -N UDP
sudo iptables -N sshguard

sudo iptables -A INPUT -p tcp --dport 22 -j sshguard
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT

sudo iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
sudo iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

sudo iptables -A INPUT -p udp -m recent --set --rsource --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -m recent --set --rsource --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset
sudo iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable

sudo iptables -A TCP -p tcp --dport 22 -j ACCEPT
sudo iptables -I TCP -p tcp -m recent --update --rsource --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset

sudo iptables -I UDP -p udp -m recent --update --rsource --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreachable

sudo iptables -P INPUT DROP
