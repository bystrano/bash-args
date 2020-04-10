#!/bin/bash
set -euo pipefail

_opt_get_all () {
    local options

    # shellcheck disable=SC2154
    options="$( _meta_get "${SCRIPT_DIR}/${SCRIPT_FILE}" "options" )"
    echo "$options" | awk '
BEGIN { RS="%% " }

/[^[:blank:]]/ {
    print $1
}
'
}

_opt_get_param () {

    _meta_get_option "${SCRIPT_DIR}/${SCRIPT_FILE}" "$1" "$2"
}

_opt_expand_short_opts () {
    local options short_options args i char

    options=$(_opt_get_all)
    short_options=""

    for opt in $options; do
        short_options="$short_options$(_opt_get_param "$opt" "short")"
    done

    args=()
    while [[ -n ${1+x} ]]; do
        if [[ "$1" =~ ^-[${short_options}]+ ]]; then
            for (( i=0; i<${#1}; i++ )); do
                char=${1:$i:1}
                if [[ $char != '-' ]]; then
                    args+=("-$char")
                fi
            done
        else
            args+=("$1")
        fi
        shift;
    done

    echo "${args[@]}"
}

opt_parse () {
    local opt opt_short opt_variable opt_value opt_found opt_default

    # shellcheck disable=SC2068,SC2046
    set -- $(_opt_expand_short_opts $@)

    # parser et valider les arguments
    CMD_OPTS="";
    CMD_ARGS=()
    while [[ -n "${1+x}" ]]; do
        if [[ ! "$1" =~ ^- ]]; then
            if [[ -z ${CMD+x} ]]; then
                CMD="$1";
            else
                CMD_ARGS+=("$1")
            fi
        else
            CMD_OPTS="$CMD_OPTS $1";
            opt="$1"
            opt_found=0

            for opt_name in $(_opt_get_all); do
                opt_short=$(_opt_get_param "$opt_name" "short")
                opt_variable=$(_opt_get_param "$opt_name" "variable")
                opt_value=$(_opt_get_param "$opt_name" "value")

                if [[ ! "$opt" == "-$opt_short" ]] && [[ ! "$opt" == "--$opt_name" ]]; then
                    continue;
                fi

                opt_found=1
                if [[ -n "$opt_value" ]]; then
                    declare -g "$opt_variable=$opt_value"
                else
                    shift
                    if [[ -z "${1+x}" ]]; then
                        out_usage_error "The $opt option requires an argument."
                    fi
                    declare -g "$opt_variable=$1"
                    CMD_OPTS="$CMD_OPTS $1"
                fi

                break;
            done

            if [[ $opt_found -eq 0 ]]; then
                if [[ "$opt" == "-h" ]] || [[ "$opt" == "--help" ]]; then
                    _help_print
                    exit;
                fi
                out_usage_error "invalid option : $opt"
            fi
        fi
        shift;
    done

    # initialiser valeurs par défaut si nécessaire
    for opt_name in $(_opt_get_all); do
        opt_variable=$(_opt_get_param "$opt_name" "variable")
        opt_default=$(_opt_get_param "$opt_name" "default")
        if [[ -n "${opt_default}" ]] && [[ -z "${!opt_variable+x}" ]]; then
            declare -g "$opt_variable=$opt_default"
        fi
    done
}
