#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local candidates cur cur_index option prev

    # shellcheck disable=2086
    _opt_get_args_list ${COMP_LINE:0:$COMP_POINT+1}

    cur_index=$((${#_ARGS[@]} - 1))
    if [[ "${COMP_LINE:(COMP_POINT-1):1}" == " " ]]; then
        cur=''
        if [[ $cur_index -gt 0 ]]; then
            prev="${_ARGS[$cur_index]}"
        fi
    else
        cur="${_ARGS[$cur_index]}"
        if [[ $cur_index -gt 0 ]]; then
            prev="${_ARGS[$cur_index-1]}"
        fi
    fi

    # shellcheck disable=2086
    _opt_get_args_list $COMP_LINE

    unset "_ARGS[0]"
    if [[ -n "$cur" ]]; then
        unset "_ARGS[$cur_index]"
    fi

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
        COMP_REPLIES=()

        if [[ -z "${CMD-}" ]]; then
            for cmd in $(_cmds_get_commands); do
                COMP_REPLIES+=("$cmd")
            done
        fi

        if [[ "${prev-}" =~ ^--(.*)$ ]]; then
            option="${BASH_REMATCH[1]}"
            if [[ $(type -t "_complete_$option") == "function" ]]; then
                eval "_complete_$option \"$cur\""
            fi
        fi

        if [[ ${#COMP_REPLIES[@]} -gt 0 ]]; then
            compgen -W "${COMP_REPLIES[*]}" -- "${cur}"
        fi
    fi

    exit 0;
}
