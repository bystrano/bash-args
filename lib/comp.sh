#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local candidates cur cur_index option

    # shellcheck disable=2086
    _opt_get_args_list ${COMP_LINE:0:$COMP_POINT+1}

    cur_index=$((${#_ARGS[@]} - 1))
    if [[ "${COMP_LINE:(COMP_POINT-1):1}" == " " ]]; then
        cur=''
    else
        cur="${_ARGS[$cur_index]}"
    fi

    # shellcheck disable=2086
    _opt_get_args_list $COMP_LINE

    unset "_ARGS[0]"
    unset "_ARGS[$cur_index]"

    _opt_expand_short_opts
    _opt_parse_args

    if [[ "$cur" =~ ^- ]]; then
        _meta_parse_options "${CMD:-}"
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

    exit 0;
}
