#!/usr/bin/env bash
set -euo pipefail

_meta_get () {
    local file meta

    file="$1"
    meta="$2"

    <"$file" awk -v meta="$meta" -f "${CMD_DIR:=.}"/lib/meta_get.awk
}

_meta_get_option () {
    local options

    options="$( _meta_get "$1" "options" )"
    echo "$options" | awk -v option="$2" -v param="$3" -f "${CMD_DIR:=.}"/lib/meta_get_option.awk
}

_meta_command_get () {

    # shellcheck disable=SC2153
    _meta_get "$SCRIPT_DIR/${CMDS_DIR}/${1}.sh" "$2"
}
