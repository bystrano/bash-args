#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local candidates cur cur_index option option_value opt_arg_comp opt_arg_required prev

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

        if [[ "${prev-}" =~ ^--(.*)$ ]]; then
            option="${BASH_REMATCH[1]}"
            option_value="$(_meta_get_opt "$option" "value")"
            opt_arg_comp="$(_meta_get_opt "$option" "argument_complete")"
            if [[ -z "$option_value" ]]; then
                opt_arg_required=1
            else
                opt_arg_required=0
            fi
        else
            option=""
            option_value=""
            opt_arg_required=0
        fi

        if [[ $opt_arg_required -eq 0 ]]; then
            if [[ -z "${CMD-}" ]]; then
                for cmd in $(_cmds_get_commands); do
                    COMP_REPLIES+=("$cmd")
                done
            else
                arg_comp="$(_meta_get "argument_complete" "$CMD")"
                _comp_complete_argument "$arg_comp"
            fi
        fi

        if [[ -n "$option" ]]; then
            _comp_complete_argument "$opt_arg_comp"
        fi

        if [[ ${#COMP_REPLIES[@]} -gt 0 ]]; then
            compgen -W "${COMP_REPLIES[*]}" -- "${cur}"
        fi
    fi

    exit 0;
}

_comp_complete_argument () {
    local arg_type

    arg_type="$1"

    if [[ -n "$arg_type" ]]; then
        if [[ $(type -t "_complete_${arg_type}") == "function" ]]; then
            eval "_complete_${arg_type} \"$cur\""
        else
            # this is a serious error we allow it to be shown when auto-completing.
            unset _SILENT
            out_fatal_error "function _complete_${arg_type} is undefined"
        fi
    fi
}

_complete_file () {

    for file in ${1-}*; do
        COMP_REPLIES+=("$file")
    done
}
