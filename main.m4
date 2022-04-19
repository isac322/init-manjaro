#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([mirror], [m], [Manjaro Mirror], [stable])
# ARG_OPTIONAL_SINGLE([type], [t], [Installation type], [server])
# ARG_OPTIONAL_SINGLE([graphic], [g], [GPU type])
# ARG_OPTIONAL_BOOLEAN([wayland], [], [Enable Wayland (Not recommended yet)])
# ARG_OPTIONAL_BOOLEAN([docker], [], [Install Docker & compose], [on])
# ARG_OPTIONAL_SINGLE([ftpd], [], [Install specified ftpd and enable sshguard for it])
# ARG_OPTIONAL_BOOLEAN([openvpn3], [], [Install openvpn3-linux])
# ARG_OPTIONAL_BOOLEAN([openssh-hpn], [], [Install hpn patched openssh])
# ARG_OPTIONAL_BOOLEAN([borg-server], [], [Install borg backup server])
# ARG_OPTIONAL_BOOLEAN([deluged], [], [Install deluge daemon])
# ARG_OPTIONAL_BOOLEAN([swapspace], [], [Install swapspace], [on])
# ARG_OPTIONAL_BOOLEAN([iptables], [], [Setup iptables], [on])
# ARG_OPTIONAL_BOOLEAN([certbot], [], [Install cerbot and enable auto renewal])
# ARG_OPTIONAL_BOOLEAN([k8s-utils], [], [Install kubernetes utilities], [on])
# ARG_OPTIONAL_BOOLEAN([dry-run], [], [Do not execute scripts])
# ARG_TYPE_GROUP_SET([instance_type], [INSTANCE_TYPE], [type], [desktop,server])
# ARG_TYPE_GROUP_SET([gpu_type], [GPU_TYPE], [graphic], [nvidia,intel])
# ARG_TYPE_GROUP_SET([mirror_type], [MIRROR_TYPE], [mirror], [testing,stable])
# ARG_TYPE_GROUP_SET([ftpd_type], [FTPD_TYPE], [ftpd], [pure-ftpd,vsftpd])
# ARGBASH_SET_DELIM([ =])
# ARG_OPTION_STACKING([getopt])
# ARG_RESTRICT_VALUES([no-local-options])
# ARG_HELP([Initial setup for manjaro])
# ARGBASH_GO

# [ <-- needed because of Argbash

mirror_type="$_arg_mirror"
instance_type="$_arg_type"

if [ "$instance_type" = 'desktop' ] && [ -z "$_arg_graphic" ]; then
  echo 'You have to specify GPU type'
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")"  &> /dev/null && pwd)"

declare -a include_list

set -ex

# instance independent

case "$mirror_type" in
  'stable') include_list+=('001-rank-mirror.bash') ;;
  'testing') include_list+=('000-setup-mirror-testing.bash') ;;
esac

include_list+=(
  '002-makepkg.bash'
  '003-pkgfile.bash'
  '004-yay.bash'
  '005-vim.bash'
  '052-htop.bash'
  '058-exfat.bash'
)

if [ "$_arg_openvpn3" = 'on' ]; then
  include_list+=('040-openvpn3.bash')
fi

if [ "$_arg_docker" = 'on' ]; then
  include_list+=('046-docker.bash')
fi

if [ "$_arg_k8s_utils" = 'on' ]; then
  include_list+=('034-k8s-utils.bash')
fi

if [ "$_arg_swapspace" = 'on' ]; then
  include_list+=('071-swapspace')
fi


# instance dependent

case "$instance_type" in
  'desktop')
    include_list+=(
      '006-zsh.bash'
      '020-cleanup-kde.bash'
      '022-basic-kde.bash'
      '023-theme-kde.bash'
      '024-jetbrains.bash'
      '026-chrome.bash'
      '028-font.bash'
      '030-ssh-agent.bash'
      '032-vorta.bash'
      '036-authy.bash'
      '038-1password.bash'
      '042-ntf3.bash'
      '044-slack.bash'
      '048-aws.bash'
      '060-gnome-utils.bash'
      '066-mpv.bash'
      '070-wine.bash'
    )

    if [ "$_arg_wayland" = 'on' ]; then
      include_list+=('016-plasma-wayland.bash')
    fi

    case "$_arg_graphic" in
      'intel') include_list+=('068-mpv-config-intel.bash') ;;
      'nvidia')
        include_list+=(
          '015-nvidia-modsetting.bash'
          '068-mpv-config-nvidia.bash'
        )

        if [ "$_arg_wayland" = 'on' ]; then
          include_list+=('018-plasma-wayland-nvidia.bash')
        fi
        ;;
    esac

    ;;
  'server')
    include_list+=(
      '006-zsh-server.bash'
      '010-iptables-nft.bash'
      '050-network-performance.bash'
    )

    if [ "$_arg_openssh_hpn" = 'on' ]; then
      include_list+=('008-openssh-hpn.bash')
    else
      include_list+=('008-openssh.bash')
    fi

    if [ "$_arg_deluged" = 'on' ]; then
      include_list+=('056-deluge-server.bash')
    fi

    if [ "$_arg_borg_server" = 'on' ]; then
      include_list+=('062-borg.bash')
    fi

    if [ "$_arg_certbot" = 'on' ]; then
      include_list+=('064-certbot.bash')
    fi

    if [ "$_arg_ftpd" = 'vsftpd' ]; then
      include_list+=('054-vsftpd.bash')
    elif [ "$_arg_ftpd" = 'pure-ftpd' ]; then
      include_list+=('054-pure-ftpd.bash')
    fi

    if [ "$_arg_iptables" = 'on' ]; then
      include_list+=(
        '009-sshguard.bash'
        '010-iptables-reset.bash'
        '011-iptables-basic.bash'
        '014-iptables-save.bash'
      )

      if [ "$_arg_deluged" = 'on' ]; then
        include_list+=('012-iptables-deluge.bash')
      fi

      if [ "$_arg_ftpd" = 'vsftpd' ]; then
        include_list+=('009-sshguard-with-vsftpd.bash' '013-iptables-ftp.bash')
      elif [ "$_arg_ftpd" = 'pure-ftpd' ]; then
        include_list+=('009-sshguard-with-pure-ftpd.bash' '013-iptables-ftp.bash')
      fi
    fi
    ;;
esac

mapfile -t script_list < <(printf "%s\n" "${include_list[@]}" | sort -n)
echo "${script_list[@]}"

for f in "${script_list[@]}"; do
  if [ "$_arg_dry_run" = 'off' ]; then
    ${SCRIPT_DIR}/components/${f}
  else
    echo "${SCRIPT_DIR}/components/${f}"
  fi
done

# ] <-- needed because of Argbash
