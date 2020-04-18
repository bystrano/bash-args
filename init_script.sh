#!/usr/bin/env bash
set -euo pipefail

if [[ "${_DEBUG:=0}" -eq 1 ]]; then
    set -E
    trap util_trace ERR
fi


####
## User Variables

TERM_WIDTH=${TERM_WIDTH:=80}
CMDS_DIR=${CMDS_DIR:=cmd}


##
# Utility

# A reimplementation of readlink -f for non-GNU systems
_readlink () {
    IFS='/' read -ra parts <<<"$1"

    # Starting point.
    local path="/"
    [[ "$1" =~ ^/ ]] || path="."

    # Process each component.
    for part in "${parts[@]}"
    do
        # All components must exist.
        [ -e "$path/$part" ] || return 1

        # If it's a link, we need to resolve it first.
        [ -L "$path/$part" ] && part="$(readlink "$path/$part")"

        # If the component starts with "/" we stomp the existing $path.
        [[ "$part" =~ ^/ ]] && path=""

        # Add the component to the path.
        path+="/$part"
    done

    # Remove any duplicate slashes.
    echo "$path" | tr -s /
}


####
## Computed Variables

read -r _ _file < <(caller)
_file="$(_readlink "$_file")"

# shellcheck disable=2034
SCRIPT_FILE="$(basename "$_file")"
# shellcheck disable=2034
SCRIPT_DIR="$(dirname "$_file")"
CMD_DIR="$(dirname "$(_readlink "${BASH_SOURCE[0]}")")"


####
## Load the lib/ files

for _file in "${CMD_DIR}"/lib/*.sh; do
    # shellcheck source=/dev/null
    . "$_file"
done


####
## Parse the arguments

_opt_process_opts "$@"
