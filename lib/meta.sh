#!/usr/bin/env bash
set -euo pipefail

_meta_get () {
    local file meta

    file="$1"
    meta="$2"

    <"$file" awk -v meta="$meta" -f lib/meta_get.awk
}

_meta_get_option () {
    local options

    # shellcheck disable=SC2154
    options="$( _meta_get "$1" "options" )"
    echo "$options" | awk -v option="$2" -v param="$3" -f lib/meta_get_option.awk
}

_meta_command_get () {

    # shellcheck disable=SC2154
    _meta_get "$SCRIPT_DIR/${CMDS_DIR}/${1}.sh" "$2"
}
