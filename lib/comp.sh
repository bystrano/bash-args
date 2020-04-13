#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local candidates cur option options

    # shellcheck disable=2086
    _opt_get_args_list $COMP_LINE

    if [[ "${COMP_LINE:(-1)}" == " " ]]; then
        cur=''
    else
        cur="${_ARGS[((${#_ARGS[@]}-1))]}"
    fi

    if [[ "$cur" =~ ^- ]]; then
        options="$(_opt_get_all)"
        candidates=""
        for option in $options; do
            short="$(_opt_get_param "$option" "short")"
            if [[ -z "$short" ]]; then
                candidates="$(printf "%s %s" "$candidates" "--$option")"
            else
                candidates="$(printf "%s %s %s" "$candidates" "-$short" "--$option")"
            fi
        done
        compgen -W "$candidates" -- "${cur}"
    else
        compgen -W "$(_cmds_get_commands)" -- "${cur}"
    fi
    exit;
}
