#!/bin/bash

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([mirror],[m],[Manjaro Mirror],[stable])
# ARG_OPTIONAL_SINGLE([type],[t],[Installation type],[server])
# ARG_OPTIONAL_SINGLE([graphic],[g],[GPU type])
# ARG_OPTIONAL_BOOLEAN([wayland],[],[Enable Wayland (Not recommended yet)])
# ARG_OPTIONAL_BOOLEAN([docker],[],[Install Docker & compose],[on])
# ARG_OPTIONAL_BOOLEAN([pure-ftpd],[],[Install pure-ftpd and enable sshguard for it])
# ARG_OPTIONAL_BOOLEAN([openvpn3],[],[Install openvpn3-linux])
# ARG_OPTIONAL_BOOLEAN([openssh-hpn],[],[Install hpn patched openssh])
# ARG_OPTIONAL_BOOLEAN([k8s-utils],[],[Install kubernetes utilities],[on])
# ARG_TYPE_GROUP_SET([instance_type],[INSTANCE_TYPE],[type],[desktop,server])
# ARG_TYPE_GROUP_SET([gpu_type],[GPU_TYPE],[graphic],[nvidia,intel])
# ARG_TYPE_GROUP_SET([mirror_type],[MIRROR_TYPE],[mirror],[testing,stable])
# ARGBASH_SET_DELIM([ =])
# ARG_OPTION_STACKING([getopt])
# ARG_RESTRICT_VALUES([no-local-options])
# ARG_HELP([Initial setup for manjaro])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


evaluate_strictness()
{
	[[ "$2" =~ ^-(-(mirror|type|graphic|wayland|docker|pure-ftpd|openvpn3|openssh-hpn|k8s-utils|help)$|[mtgh]) ]] && die "You have passed '$2' as a value of argument '$1', which makes it look like that you have omitted the actual value, since '$2' is an option accepted by this script. This is considered a fatal error."
}

# validators

instance_type()
{
	local _allowed=("desktop" "server") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'desktop' and 'server'" 4
}


gpu_type()
{
	local _allowed=("nvidia" "intel") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'nvidia' and 'intel'" 4
}


mirror_type()
{
	local _allowed=("testing" "stable") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'testing' and 'stable'" 4
}


begins_with_short_option()
{
	local first_option all_short_options='mtgh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_mirror="stable"
_arg_type="server"
_arg_graphic=
_arg_wayland="off"
_arg_docker="on"
_arg_pure_ftpd="off"
_arg_openvpn3="off"
_arg_openssh_hpn="off"
_arg_k8s_utils="on"


print_help()
{
	printf '%s\n' "Initial setup for manjaro"
	printf 'Usage: %s [-m|--mirror <MIRROR_TYPE>] [-t|--type <INSTANCE_TYPE>] [-g|--graphic <GPU_TYPE>] [--(no-)wayland] [--(no-)docker] [--(no-)pure-ftpd] [--(no-)openvpn3] [--(no-)openssh-hpn] [--(no-)k8s-utils] [-h|--help]\n' "$0"
	printf '\t%s\n' "-m, --mirror: Manjaro Mirror. Can be one of: 'testing' and 'stable' (default: 'stable')"
	printf '\t%s\n' "-t, --type: Installation type. Can be one of: 'desktop' and 'server' (default: 'server')"
	printf '\t%s\n' "-g, --graphic: GPU type. Can be one of: 'nvidia' and 'intel' (no default)"
	printf '\t%s\n' "--wayland, --no-wayland: Enable Wayland (Not recommended yet) (off by default)"
	printf '\t%s\n' "--docker, --no-docker: Install Docker & compose (on by default)"
	printf '\t%s\n' "--pure-ftpd, --no-pure-ftpd: Install pure-ftpd and enable sshguard for it (off by default)"
	printf '\t%s\n' "--openvpn3, --no-openvpn3: Install openvpn3-linux (off by default)"
	printf '\t%s\n' "--openssh-hpn, --no-openssh-hpn: Install hpn patched openssh (off by default)"
	printf '\t%s\n' "--k8s-utils, --no-k8s-utils: Install kubernetes utilities (on by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-m|--mirror)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_mirror="$(mirror_type "$2" "mirror")" || exit 1
				shift
				evaluate_strictness "$_key" "$_arg_mirror"
				;;
			--mirror=*)
				_arg_mirror="$(mirror_type "${_key##--mirror=}" "mirror")" || exit 1
				evaluate_strictness "$_key" "$_arg_mirror"
				;;
			-m*)
				_arg_mirror="$(mirror_type "${_key##-m}" "mirror")" || exit 1
				evaluate_strictness "$_key" "$_arg_mirror"
				;;
			-t|--type)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_type="$(instance_type "$2" "type")" || exit 1
				shift
				evaluate_strictness "$_key" "$_arg_type"
				;;
			--type=*)
				_arg_type="$(instance_type "${_key##--type=}" "type")" || exit 1
				evaluate_strictness "$_key" "$_arg_type"
				;;
			-t*)
				_arg_type="$(instance_type "${_key##-t}" "type")" || exit 1
				evaluate_strictness "$_key" "$_arg_type"
				;;
			-g|--graphic)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_graphic="$(gpu_type "$2" "graphic")" || exit 1
				shift
				evaluate_strictness "$_key" "$_arg_graphic"
				;;
			--graphic=*)
				_arg_graphic="$(gpu_type "${_key##--graphic=}" "graphic")" || exit 1
				evaluate_strictness "$_key" "$_arg_graphic"
				;;
			-g*)
				_arg_graphic="$(gpu_type "${_key##-g}" "graphic")" || exit 1
				evaluate_strictness "$_key" "$_arg_graphic"
				;;
			--no-wayland|--wayland)
				_arg_wayland="on"
				test "${1:0:5}" = "--no-" && _arg_wayland="off"
				;;
			--no-docker|--docker)
				_arg_docker="on"
				test "${1:0:5}" = "--no-" && _arg_docker="off"
				;;
			--no-pure-ftpd|--pure-ftpd)
				_arg_pure_ftpd="on"
				test "${1:0:5}" = "--no-" && _arg_pure_ftpd="off"
				;;
			--no-openvpn3|--openvpn3)
				_arg_openvpn3="on"
				test "${1:0:5}" = "--no-" && _arg_openvpn3="off"
				;;
			--no-openssh-hpn|--openssh-hpn)
				_arg_openssh_hpn="on"
				test "${1:0:5}" = "--no-" && _arg_openssh_hpn="off"
				;;
			--no-k8s-utils|--k8s-utils)
				_arg_k8s_utils="on"
				test "${1:0:5}" = "--no-" && _arg_k8s_utils="off"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash
# Validation of values




### END OF CODE GENERATED BY Argbash (sortof) ### ])
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