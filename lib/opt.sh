#!/usr/bin/env bash
set -euo pipefail

_opt_expand_short_opts () {
    local opt item options short_options args i char

    options=$(_meta_get_all_opts)
    short_options=""

    for opt in $options; do
        short_options="$short_options$(_meta_get_opt "$opt" "short")"
    done

    if [[ "${#_ARGS[@]}" -gt 0 ]]; then
        args=()
        for item in "${_ARGS[@]}"; do
            if [[ "$item" =~ ^-[${short_options}]+ ]]; then
                for (( i=0; i<${#item}; i++ )); do
                    char=${item:$i:1}
                    if [[ $char != '-' ]]; then
                        args+=("-$char")
                    fi
                done
            else
                args+=("$item")
            fi
        done

        _ARGS=("${args[@]}")
    fi
}

_opt_get_name () {
    local name short

    for name in $(_meta_get_all_opts); do

        short=$(_meta_get_opt "$name" "short")

        if [[ "$1" == "-$short" ]] || [[ "$1" == "--$name" ]]; then
            printf "%s" "$name"
            break;
        fi
    done
}

_opt_interpret () {
    local name argument type default value variable

    name="${1##--}"
    shift
    argument="$*"

    type=$(_meta_get_opt "$name" "type")
    default=$(_meta_get_opt "$name" "default")
    value=$(_meta_get_opt "$name" "value")
    variable=$(_meta_get_opt "$name" "variable")

    if [[ "$type" == "flag" ]]; then
        export "$variable=$value"
    else
        if [[ -n "$argument" ]]; then
            export "$variable=$argument"
        elif [[ -n "$value" ]]; then
            export "$variable=$value"
        elif [[ "$name" == "help" ]]; then
            if [[ -z "${CMD+x}" ]]; then
                _help_print_main
            else
                _help_print_subcommand "$CMD"
            fi
            exit 0
        else
            out_usage_error "The --$name option requires an argument."
        fi
    fi
}

_opt_interpret_default () {
    local name variable default

    name="$1"
    variable=$(_meta_get_opt "$name" "variable")
    default=$(_meta_get_opt "$name" "default")

    if [[ -z "${!variable+x}" ]]; then
        if [[ -n "${default}" ]]; then
            export "$variable=$default"
        else
            out_usage_error "The --$name option is required."
        fi
    fi
}

_opt_get_args_list () {

    _ARGS=()
    while [[ -n "${1+x}" ]]; do
        _ARGS+=("$1")
        shift
    done
}

_opt_parse () {
    local opt opt_name item skip_next

    _opt_get_args_list "$@"
    _opt_expand_short_opts

    CMD_OPTS=()
    CMD_ARGS=()
    for (( i=0; i<${#_ARGS[@]}; i++ )); do

        if [[ "${skip_next:=0}" -eq 1 ]]; then
            skip_next=0
            continue
        fi

        item=${_ARGS[i]}

        if [[ ! "$item" =~ ^- ]]; then
            if [[ -z ${CMD+x} ]]; then
                CMD="$item";
            else
                CMD_ARGS+=("$item")
            fi
        else
            opt="$item"
            if [[ "$opt" == "-h" ]] || [[ "$opt" == "--help" ]]; then
                opt_name="help"
            else
                opt_name=$(_opt_get_name "$opt")
            fi

            if [[ -z "$opt_name" ]]; then
                out_usage_error "invalid option : $opt"
            fi

            if [[ "$(_meta_get_opt "$opt_name" "type")" == "option" ]] &&
                   [[ -n "${_ARGS[i+1]+x}" ]] &&
                   [[ ! "${_ARGS[i+1]}" =~ ^- ]]; then
                CMD_OPTS+=("--$opt_name ${_ARGS[i+1]}")
                skip_next=1
            else
                CMD_OPTS+=("--$opt_name")
            fi
        fi
    done

    if [[ "${#CMD_OPTS[@]}" -gt 0 ]]; then
        for opt in "${CMD_OPTS[@]}"; do
            # shellcheck disable=SC2086
            _opt_interpret $opt
        done
    fi

    for opt in $(_meta_get_all_opts); do
        _opt_interpret_default "$opt"
    done
}
