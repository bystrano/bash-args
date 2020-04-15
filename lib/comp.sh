#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local candidates cur cur_index option options

    # shellcheck disable=2086
    _opt_get_args_list $COMP_LINE

    unset "_ARGS[0]"

    if [[ "${COMP_LINE:(-1)}" == " " ]]; then
        cur=''
    else
        cur_index=${#_ARGS[@]}
        cur="${_ARGS[$cur_index]}"
        unset "_ARGS[$cur_index]"
    fi

    _opt_expand_short_opts
    _opt_parse_args

    if [[ "$cur" =~ ^- ]]; then
        options="$(_meta_get_all_opts "${CMD:-}")"
        candidates=""
        for option in $options; do
            short="$(_meta_get_opt "$option" "short")"
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
