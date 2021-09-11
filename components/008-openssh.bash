#!/usr/bin/env bash

function modify_sshd_config() {
  local val="$1"
  shift
  local cfg_path='/etc/ssh/sshd_config'

  local exprs=()
  for key in "$@"; do
    if grep -qE "^\s*#\s*${key}\s+${val}\s*$" "$cfg_path"; then
      exprs+=(-e "s/^\s*#\s*${key}\s+.+$/${key} ${val}/")
    else
      exprs+=(-e "s/^\s*#\s*${key}\s+(.+)$/${key} ${val}\t# \1/")
    fi
  done

  sudo sed -i -E "${exprs[@]}" "$cfg_path"
}

set -ex

yay -S openssh --noconfirm --removemake --needed

modify_sshd_config 'no' 'PermitEmptyPasswords' 'PermitRootLogin' 'Compression'
modify_sshd_config 'yes' 'PubkeyAuthentication' 'StrictModes' 'PasswordAuthentication'
modify_sshd_config '1' 'MaxAuthTries'

sudo rm /etc/ssh/ssh_host_*
sudo ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli > /dev/null
sudo sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config
cat <<EOF | sudo tee -a /etc/ssh/sshd_config > /dev/null

# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com
# hardening guide.
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,ssh-rsa
EOF

sudo systemctl enable --now sshd
