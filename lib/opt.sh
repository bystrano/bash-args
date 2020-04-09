#!/bin/bash
set -euo pipefail

_opt_get_all () {
    local options

    # shellcheck disable=SC2154
    options="$( _meta_get "${script_dir}/spipsh" "options" )"
    echo "$options" | awk '
BEGIN { RS="%% " }

/[^[:blank:]]/ {
    print $1
}
'
}

_opt_get_param () {

    _meta_get_option "${script_dir}/spipsh" "$1" "$2"
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
    spipsh_opts="";
    cmd_args=()
    while [[ -n "${1+x}" ]]; do
        if [[ ! "$1" =~ ^- ]]; then
            if [[ -z ${cmd+x} ]]; then
                cmd="$1";
            else
                cmd_args+=("$1")
            fi
        else
            spipsh_opts="$spipsh_opts $1";
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
                        out_usage_error "L'option $opt nécessite un argument."
                    fi
                    declare -g "$opt_variable=$1"
                    spipsh_opts="$spipsh_opts $1"
                fi

                break;
            done

            if [[ $opt_found -eq 0 ]]; then
                out_usage_error "option invalide : $opt"
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
