#!/usr/bin/env bash
set -euo pipefail

_opt_expand_short_opts () {
    local opt item args i char

    if [[ "${#_ARGS[@]}" -gt 0 ]]; then
        args=()
        for item in "${_ARGS[@]}"; do
            if [[ "$item" =~ ^-[a-zA-Z]+ ]]; then
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

    for name in "${_OPTIONS[@]}"; do

        short=$(_meta_get_opt "$name" "short")

        if [[ "$1" == "-$short" ]] || [[ "$1" == "--$name" ]]; then
            printf "%s" "$name"
            break;
        fi
    done
}

_opt_interpret () {
    local subcmd name argument type default value variable

    subcmd="$1"
    shift
    name="${1##--}"
    shift
    argument="$*"

    type=$(_meta_get_opt "$name" "type" "$subcmd")
    default=$(_meta_get_opt "$name" "default" "$subcmd")
    value=$(_meta_get_opt "$name" "value" "$subcmd")
    variable=$(_meta_get_opt "$name" "variable" "$subcmd")

    if [[ "$type" == "flag" ]]; then
        if [[ "$name" == "help" ]]; then
            if [[ -z "${CMD+x}" ]]; then
                _help_print_main
            else
                _help_print_subcommand "$CMD"
            fi
            exit 0
        elif [[ "$name" == "version" ]]; then
            _help_print_version
            exit 0
        else
            export "$variable=$value"
        fi
    else
        if [[ -n "$argument" ]]; then
            export "$variable=$argument"
        elif [[ -n "$value" ]]; then
            export "$variable=$value"
        else
            out_usage_error "The --$name option requires an argument."
        fi
    fi
}

_opt_interpret_default () {
    local subcmd name variable default

    subcmd="$1"
    name="$2"
    variable=$(_meta_get_opt "$name" "variable" "$1")
    default=$(_meta_get_opt "$name" "default" "$1")

    if [[ -z "$variable" ]] && [[ "$name" == "help" ]]; then
        return
    fi

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

_opt_parse_args () {
    local skip_next item opt opt_name

    unset CMD
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

                # shellcheck disable=2235
                if [[ "$item" == "_complete" ]]; then
                    # shellcheck disable=2034
                    _SILENT=1
                    _comp_complete
                    exit 0
                elif [[ "$item" == "_register_completion" ]]; then
                    printf "complete -C '%s _complete' %s\n" "$(realpath "$SCRIPT_DIR"/"$SCRIPT_FILE")" "$SCRIPT_FILE"
                    exit 0
                elif [[ "$item" == "help" ]] || ( [[ -d "$SCRIPT_DIR/$CMDS_DIR" ]] && [[ -f "$SCRIPT_DIR/$CMDS_DIR/${item}.sh" ]] ); then
                    CMD="$item"
                    # now that we know the command, we add its option definitions.
                    _meta_parse_options "$CMD"
                else
                    CMD_ARGS+=("$item")
                fi
            else
                CMD_ARGS+=("$item")
            fi
        else
            opt="$item"
            opt_name=$(_opt_get_name "$opt")

            if [[ -z "$opt_name" ]]; then
                out_usage_error "invalid option : $opt"
            fi

            if [[ "$(_meta_get_opt "$opt_name" "type" "${CMD-}")" == "option" ]] &&
                   [[ -n "${_ARGS[i+1]+x}" ]] &&
                   [[ ! "${_ARGS[i+1]}" =~ ^- ]]; then
                CMD_OPTS+=("--$opt_name ${_ARGS[i+1]}")
                skip_next=1
            else
                CMD_OPTS+=("--$opt_name")
            fi
        fi
    done
}

_opt_process_opts () {
    local opt

    _meta_read_files
    _meta_parse_options

    # computes the _ARGS array
    _opt_get_args_list "$@"
    # mutates the _ARGS array
    _opt_expand_short_opts
    # parse the _ARGS to compute the CMD, CMD_ARGS and CMD_OPTS arrays.
    _opt_parse_args

    if [[ "${#CMD_OPTS[@]}" -gt 0 ]]; then
        for opt in "${CMD_OPTS[@]}"; do
            # shellcheck disable=SC2086
            _opt_interpret "${CMD-}" $opt
        done
    fi

    if [[ ${#_OPTIONS[@]} -gt 0 ]]; then
        for opt in "${_OPTIONS[@]}"; do
            if [[ -n "$opt" ]]; then
                _opt_interpret_default "${CMD-}" "$opt"
            fi
        done
    fi
}
