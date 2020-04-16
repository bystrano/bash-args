#!/usr/bin/env bash
set -euo pipefail

_meta_get () {

    _meta_get_raw "$1" "${2-}" "${3-}" | tr -d '\n'
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
    elif [[ "${2-}" == "help" ]] && [[ "$meta" == "summary" ]]; then
        echo "Show help about subcommands."
    fi
}

_meta_get_all_opts () {
    local options opt def

    if [[ -n "${1:-}" ]]; then
        options="$( _meta_get_raw "options" "$1" )"
    fi

    _OPTIONS=("help")
    _OPTIONS_DEFS=("short=h")

    def=""
    options="${options:-}$( _meta_get_raw "options" )"
    while read -r line; do
        if [[ "$line" =~ ^% ]]; then
            opt="${line:2}"

            if [[ -n "$def" ]]; then
                _OPTIONS_DEFS+=("$def")
                def=""
            fi

            # if [[ ${#_OPTIONS[@]} -gt 0 ]] && util_in_array "$opt" "${_OPTIONS[@]}"; then
            #     out_fatal_error "duplicate options definition : $opt"
            # fi

            # if a help option is defined, we remove the default one.
            if [[ "$opt" == "help " ]]; then
                unset "_OPTIONS[0]"
                unset "_OPTIONS_DEFS[0]"
            fi

            _OPTIONS+=("$opt")
        elif [[ -n "$line" ]]; then
            def="$def $line"
        fi
    done <<< "$options"
    _OPTIONS_DEFS+=("$def")
}

_meta_get_opt () {
    local i name

    name="$2"
    for (( i=0; i<${#_OPTIONS[@]}; i++ )); do
        if [[ "${_OPTIONS[$i]}" == "$1" ]]; then
            if [[ -n "${!name+x}" ]]; then
                unset "$name"
            fi
            eval "${_OPTIONS_DEFS[$i]} && printf \"%s\" \"\${${name}-}\""
            return
        fi
    done
}
