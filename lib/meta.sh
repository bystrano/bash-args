#!/usr/bin/env bash
set -euo pipefail

meta_get () {

    _meta_get_raw "$1" "${2-}" | tr -d '\n'
}

_meta_get_raw () {
    local meta cmd meta_var

    meta="$1"
    cmd="${2-}"

    meta_var="_METAS_${cmd//-/_}_${meta}"
    if [[ -n "${!meta_var+x}" ]]; then
        printf "%s" "${!meta_var}"
    elif [[ "${2-}" == "help" ]] && [[ "$meta" == "summary" ]]; then
        echo "Show help about subcommands."
    fi
}

_meta_read_files () {
    local cmd file

    eval "$(<"${SCRIPT_DIR}/${SCRIPT_FILE}" awk -v cmd="" -f "${CMD_DIR}"/lib/meta_read.awk)"

    if [[ -d "${SCRIPT_DIR}/${CMDS_DIR}" ]]; then
        for file in "${SCRIPT_DIR}/${CMDS_DIR}"/*.sh; do
            cmd="$(basename "$file")"
            cmd="${cmd:0:$((${#cmd}-3))}"
            eval "$(<"$file" awk -v cmd="$cmd" -f "${CMD_DIR}"/lib/meta_read.awk)"
        done
    fi
}

_meta_parse_options () {
    local options opt def

    if [[ -n "${1:-}" ]]; then
        options="$( _meta_get_raw "options" "$1" )"
    fi

    _OPTIONS=("help")
    _OPTIONS_DEFS=("type=flag variable=help value=1 default=0 short=h desc='Show this help.'")

    if [[ -n "$(meta_get "version")" ]]; then
        _OPTIONS+=("version")
        _OPTIONS_DEFS+=("type=flag variable=version value=1 default=0 desc='Show version informations.'")
    fi

    def=""
    options="$(printf '%s\n%s' "${options-}" "$(_meta_get_raw "options")")"
    while read -r line; do
        if [[ "$line" =~ ^% ]]; then
            opt="${line:2}"

            if [[ ! "$opt" =~ ^[[:alnum:]_-]+$ ]]; then
                out_fatal_error "invalid option name : $opt"
            fi

            if [[ ${#_OPTIONS[@]} -gt 0 ]] && util_in_array "$opt" "${_OPTIONS[@]}"; then
                out_fatal_error "duplicate option definitions : $opt"
            fi

            if [[ -n "$def" ]]; then
                _meta_validate_opt_def "$opt" "$def"
                _OPTIONS_DEFS+=("$def")
                def=""
            fi

            # if a help option is defined, we remove the default one.
            if [[ "$opt" == "help " ]]; then
                unset "_OPTIONS[0]"
                unset "_OPTIONS_DEFS[0]"
            fi

            _OPTIONS+=("$opt")
        elif [[ -n "$line" ]]; then
            def="$def $line"
        fi
    done <<< "$options"

    if [[ -n "${opt-}" ]]; then
        _meta_validate_opt_def "$opt" "$def"
        _OPTIONS_DEFS+=("$def")
    fi
}

_meta_validate_opt_def () {

    eval "$2; printf '%s-%s-%s-%s\n' \"\${variable-}\" \"\${type-}\" \"\${value-}\" \"\${default-}\"" \
        | while IFS=- read -r variable type value default; do
        if [[ -z "$variable" ]]; then
            out_fatal_error "missing \"variable\" parameter in option \"$1\""
        elif [[ -z "$type" ]]; then
            out_fatal_error "missing \"type\" parameter in option \"$1\""
        elif ! util_in_array "$type" "flag" "option"; then
            out_fatal_error "\"type\" parameter in option $1 should be either \"flag\" or \"option\""
        elif [[ "$type" == "flag" ]] && [[ -z "$value" ]]; then
            out_fatal_error "option \"$1\" is missing a \"value\" parameter"
        elif [[ "$type" == "flag" ]] && [[ -z "$default" ]]; then
            out_fatal_error "option \"$1\" is missing a \"default\" parameter"
        fi
    done
}

_meta_get_opt () {
    local i name

    name="$2"
    for (( i=0; i<${#_OPTIONS[@]}; i++ )); do
        if [[ "${_OPTIONS[$i]}" == "$1" ]]; then
            if [[ -n "${!name+x}" ]]; then
                unset "$name"
            fi
            eval "${_OPTIONS_DEFS[$i]} && printf \"%s\" \"\${${name}-}\""
            return
        fi
    done
}
