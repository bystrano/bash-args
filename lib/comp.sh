#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local candidates cur cur_index option

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
        _meta_read_options_defs "${CMD:-}"
        candidates=""
        for option in "${_OPTIONS[@]}"; do
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
