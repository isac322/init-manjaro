#!/usr/bin/env bash

set -ex

echo 'tcp_bbr' | sudo tee /etc/modules-load.d/tcp_bbr.conf > /dev/null

cat <<EOF | sudo tee /etc/sysctl.d/98-network-performance.conf > /dev/null
net.core.netdev_max_backlog = 16384

net.core.somaxconn = 8192

net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216

net.ipv4.tcp_fastopen = 3

net.ipv4.tcp_max_syn_backlog = 8192

net.ipv4.tcp_max_tw_buckets = 2000000

net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_fin_timeout = 10

net.ipv4.tcp_slow_start_after_idle = 0

net.ipv4.tcp_mtu_probing = 1

net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr
EOF

sudo modprobe tcp_bbr
sudo sysctl --system
