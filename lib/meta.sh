#!/usr/bin/env bash
set -euo pipefail

_meta_get () {
    local file meta

    meta="$1"
    if [[ -z "${2-}" ]]; then
        file="${SCRIPT_DIR:=.}/${SCRIPT_FILE:=}"
    else
        file="${SCRIPT_DIR:=.}/${CMDS_DIR:=cmd}/$2.sh"
    fi

    # for tests
    if [[ -n "${3-}" ]]; then
        file="$3"
    fi

    <"$file" awk -v meta="$meta" -f "${CMD_DIR:=.}"/lib/meta_get.awk
}

_meta_get_all_opts () {
    local options

    if [[ -n "${1:-}" ]]; then
        options="$( _meta_get "options" "$1" )"
        echo "$options" | awk -v all=1 -f "${CMD_DIR:-.}"/lib/meta_get_option.awk
    fi

    options="$( _meta_get "options" )"
    echo "$options" | awk -v all=1 -f "${CMD_DIR:-.}"/lib/meta_get_option.awk
}

_meta_get_opt () {
    local options

    if [[ -n "${3:-}" ]]; then
        options="$( _meta_get "options" "${3:-}" "${4:-}")" # the last argument is for tests
        echo "$options" | awk -v option="$1" -v param="$2" -f "${CMD_DIR:-.}"/lib/meta_get_option.awk
    fi

    options="$( _meta_get "options" "" "${4-}")"
    echo "$options" | awk -v option="$1" -v param="$2" -f "${CMD_DIR:-.}"/lib/meta_get_option.awk
}
