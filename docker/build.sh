#!/usr/bin/env bash

# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
#
# ARG_OPTIONAL_SINGLE([image],[i],[image name])
# ARG_OPTIONAL_BOOLEAN([push],[],[push image])
# ARG_HELP([The general script's help msg])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

# exit program when any command failed
set -e

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}


begins_with_short_option()
{
	local first_option all_short_options='ih'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_image="$IMAGE"
_arg_push="off"


print_help()
{
	printf '%s\n' "The general script's help msg"
	printf 'Usage: %s [-i|--image <arg>] [--(no-)push] [-h|--help]\n' "$0"
	printf '\t%s\n' "-i, --image: image name (default: ${_arg_image})"
	printf '\t%s\n' "--push, --no-push: push image (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-i|--image)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_image="$2"
				shift
				;;
			--image=*)
				_arg_image="${_key##--image=}"
				;;
			-i*)
				_arg_image="${_key##-i}"
				;;
			--no-push|--push)
				_arg_push="on"
				test "${1:0:5}" = "--no-" && _arg_push="off"
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

# directory of this file
CUR=$(dirname $0)
CUR=`cd $CUR; pwd`

# project root path 
PROJ_ROOT=$CUR/..

echo "image name = $_arg_image"

pushd $PROJ_ROOT >> /dev/null

# install dependencies
npm i

# build docker image
docker build -f Dockerfile -t $_arg_image .

popd >> /dev/null

if [[ $_arg_push == 'on' ]]; then
  docker push $_arg_image
fi
