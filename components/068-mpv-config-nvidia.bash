#!/usr/bin/env bash

set -ex

cat <<EOF | sudo tee /etc/mpv/mpv.conf > /dev/null
hwdec=nvdec
save-position-on-quit
profile=gpu-hq
video-latency-hacks=yes
scale=spline36
scale=ewa_lanczossharp
cscale=ewa_lanczossharp
video-sync=display-resample
interpolation
tscale=oversample
opengl-pbo
deband
osd-on-seek=msg
osd-font='NanumGothic'
osd-font-size=30
screenshot-format=png
screenshot-png-compression=9
screenshot-tag-colorspace=yes
slang=ko,kor
vo=gpu
EOF
