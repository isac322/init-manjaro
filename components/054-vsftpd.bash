#!/usr/bin/env bash

set -ex

yay -S vsftpd --noconfirm --removemake --needed

cat <<EOF | sudo tee /etc/vsftpd.conf > /dev/null
anonymous_enable=NO
chmod_enable=YES
chroot_local_user=YES
delete_failed_uploads=YES
force_local_data_ssl=YES
force_local_logins_ssl=YES
guest_enable=NO
implicit_ssl=NO
listen=YES
listen_ipv6=NO
local_enable=YES
passwd_chroot_enable=YES
pasv_addr_resolve=YES
pasv_enable=YES
session_support=YES
require_ssl_reuse=NO
ssl_enable=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_tlsv1=YES
strict_ssl_read_eof=YES
strict_ssl_write_shutdown=YES
syslog_enable=YES
use_localtime=YES
validate_cert=YES
write_enable=YES

pasv_min_port=50000
pasv_max_port=51000
allow_writeable_chroot=YES

connect_from_port_20=NO
pam_service_name=vsftpd

rsa_cert_file=/etc/letsencrypt/live/`hostnamectl hostname`/cert.pem
rsa_private_key_file=/etc/letsencrypt/live/`hostnamectl hostname`/privkey.pem

ssl_ciphers=MEDIUM:HIGH:!SSLv2:!aNULL:!eNULL:!NULL:!EXPORT:!TLSv1
EOF

sudo sed -i -E 's/^#?(\s*auth\s+required\s+\/lib\/security\/pam_listfile.so\s+.+)$/#\1/' /etc/pam.d/vsftpd
sudo systemctl enable --now vsftpd
