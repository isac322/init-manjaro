#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([mirror], [m], [Manjaro Mirror], [stable])
# ARG_OPTIONAL_SINGLE([type], [t], [Installation type], [server])
# ARG_OPTIONAL_SINGLE([graphic], [g], [GPU type])
# ARG_OPTIONAL_BOOLEAN([wayland], [], [Enable Wayland (Not recommended yet)])
# ARG_OPTIONAL_BOOLEAN([docker], [], [Install Docker & compose], [on])
# ARG_OPTIONAL_BOOLEAN([pure-ftpd], [], [Install pure-ftpd and enable sshguard for it])
# ARG_OPTIONAL_BOOLEAN([openvpn3], [], [Install openvpn3-linux])
# ARG_OPTIONAL_BOOLEAN([openssh-hpn], [], [Install hpn patched openssh])
# ARG_OPTIONAL_BOOLEAN([k8s-utils], [], [Install kubernetes utilities], [on])
# ARG_TYPE_GROUP_SET([instance_type], [INSTANCE_TYPE], [type], [desktop,server])
# ARG_TYPE_GROUP_SET([gpu_type], [GPU_TYPE], [graphic], [nvidia,intel])
# ARG_TYPE_GROUP_SET([mirror_type], [MIRROR_TYPE], [mirror], [testing,stable])
# ARGBASH_SET_DELIM([ =])
# ARG_OPTION_STACKING([getopt])
# ARG_RESTRICT_VALUES([no-local-options])
# ARG_HELP([Initial setup for manjaro])
# ARGBASH_GO

# [ <-- needed because of Argbash

mirror_type=$_arg_mirror
instance_type=$_arg_type

if [ "$instance_type" = 'desktop' ] && [ -z "$_arg_graphic" ]; then
  echo 'You have to specify GPU type'
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")"  &> /dev/null && pwd)"

declare -a exclude_list

iptable=(
  '010-iptables-reset.bash'
  '011-iptables-basic.bash'
  '012-iptables-deluge.bash'
  '013-iptables-ftp.bash'
  '014-iptables-save.bash'
)
kde=(
  '020-cleanup-kde.bash'
  '022-basic-kde.bash'
  '023-theme-kde.bash'
  '030-ssh-agent.bash'
)
kde_wayland=(
  '016-plasma-wayland.bash'
  '018-plasma-wayland-nvidia.bash'
)
desktop_app=(
  '024-jetbrains.bash'
  '026-chrome.bash'
  '032-vorta.bash'
  '036-authy.bash'
  '044-slack.bash'
)
graphic_nvidia=(
  '015-nvidia-modsetting.bash'
)
desktop_only=(
  '005-vim-clipboard.bash'
  '006-zsh.bash'
  '028-font.bash'
  '038-1password.bash'
  '042-ntf3.bash'
  '048-aws.bash'
)
server_only=(
  '005-vim.bash'
  '006-zsh-server.bash'
  '008-openssh.bash'
  '008-openssh-hpn.bash'
  '009-sshguard.bash'
  '009-sshguard-with-pure-ftpd.bash'
  '050-network-performance.bash'
)

set -ex

case "$mirror_type" in
  'stable') exclude_list+=('000-*.bash');;
  'testing') exclude_list+=('001-*.bash');;
esac

case "$instance_type" in
  'desktop')
    exclude_list+=(
      "${server_only[@]}"
    )
    exclude_list+=("${iptable[@]}")

    if [ $_arg_wayland = 'off' ]; then
      exclude_list+=("${kde_wayland[@]}")
    fi

    case $_arg_graphic in
    'intel') exclude_list+=("${graphic_nvidia[@]}");;
    'nvidia') noop;;
    esac

    ;;
  'server')
    exclude_list+=(
      "${kde[@]}"
      "${kde_wayland[@]}"
      "${desktop_app[@]}"
      "${graphic_nvidia[@]}"
      "${desktop_only[@]}"
    )

    if [ $_arg_openssh_hpn = 'off' ]; then
      exclude_list+=('008-openssh-hpn.bash')
    else
      exclude_list+=('008-openssh.bash')
    fi

    if [ $_arg_pure_ftpd = 'off' ]; then
      exclude_list+=('009-sshguard-with-pure-ftpd.bash' '013-iptables-ftp.bash')
    else
      exclude_list+=('009-sshguard.bash')
    fi
    ;;
esac

if [ $_arg_openvpn3 = 'off' ]; then
  exclude_list+=('040-openvpn3.bash')
fi

if [ $_arg_docker = 'off' ]; then
  exclude_list+=('046-docker.bash')
fi

if [ $_arg_openssh_hpn = 'off' ]; then
  exclude_list+=('046-docker.bash')
fi

if [ $_arg_k8s_utils = 'off' ]; then
  exclude_list+=('034-k8s-utils.bash')
fi

exclude_list=( "${exclude_list[@]/#/-not -name }" )
echo "${exclude_list[@]}"

mapfile -t < <(find "$SCRIPT_DIR/components" -type f -name '*.bash' ${exclude_list[@]} | sort)
for f in "${MAPFILE[@]}"; do
  echo "$f"
done


# ] <-- needed because of Argbash
