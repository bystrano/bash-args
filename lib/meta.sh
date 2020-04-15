#!/usr/bin/env bash
set -euo pipefail

_meta_get () {

    _meta_get_raw "$1" "${2-}" "${3-}" | tr --delete '\n'
}

_meta_get_raw () {
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

    # the help and _complete subcommand may be absent.
    if [[ -f "$file" ]] || [[ "${2-}" != "help" ]] && [[ "${2-}" != "_complete" ]]; then
        <"$file" awk -v meta="$meta" -f "${CMD_DIR:=.}"/lib/meta_get.awk
    fi
}

_meta_get_all_opts () {
    local options

    if [[ -z "${_OPTIONS+x}" ]]; then
        if [[ -n "${1:-}" ]]; then
            options="$( _meta_get_raw "options" "$1" )"
        fi

        options="${options:-}$( _meta_get_raw "options" )"
        _OPTIONS="$(awk -v all=1 -f "${CMD_DIR:-.}"/lib/meta_get_option.awk <<<"$options")"
    fi

    printf "%s\n" "${_OPTIONS[*]}"
}

_meta_get_opt () {
    local options

    if [[ -n "${3:-}" ]]; then
        options="$( _meta_get "options" "${3:-}" "${4:-}")" # the last argument is for tests
        echo "$options" | awk -v option="$1" -v param="$2" -f "${CMD_DIR:-.}"/lib/meta_get_option.awk
    fi

    options="$( _meta_get "options" "" "${4-}")"
    awk -v option="$1" -v param="$2" -f "${CMD_DIR:-.}"/lib/meta_get_option.awk <<<"$options"
}
