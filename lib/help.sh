#!/bin/bash
set -euo pipefail

_help_print() {
    local help desc cmds opts

    if [[ -n "${desc:="$(_help_description)"}" ]]; then
        printf -v help "%s" "$desc"
    fi

    if [[ -n "${usage:="$(_help_usage)"}" ]]; then
        printf -v help "%s\n\nUsage : %s" "${help=:}" "$usage"
    fi

    if [[ -n "${cmds:="$(_help_commands)"}" ]]; then
        printf -v help "%s\n\nCommands :\n\n%s" "${help=:}" "$cmds"
    fi

    if [[ -n "${opts:="$(_help_options)"}" ]]; then
        printf -v help "%s\n\nOptions :\n\n%s" "${help=:}" "$opts"
    fi

    printf "%s\n" "${help=:}"
}

_help_description () {
    local description

    # shellcheck disable=SC2154
    if [[ -n "${description:="$(_meta_get "${SCRIPT_DIR}/${SCRIPT_FILE}" "description" | fmt --width="${TERM_WIDTH}")"}" ]]; then
        printf "%s" "$description"
    fi
}

_help_usage () {
    local usage

    # shellcheck disable=SC2154
    if [[ -n "${usage:="$(_meta_get "${SCRIPT_DIR}/${SCRIPT_FILE}" "usage")"}" ]]; then
        printf "%s" "$usage"
    else
        printf "%s [OPTIONS]" "$SCRIPT_FILE"
    fi
}

_help_commands () {
    local cmds max_cmd_length line_index

    cmds=$(_cmds_get_commands)

    max_cmd_length=0
    for cmd in $cmds; do
        if [[ ${#cmd} -gt $max_cmd_length ]]; then
            max_cmd_length=${#cmd}
        fi
    done

    cmd_col_width=$((max_cmd_length + 1))
    # shellcheck disable=SC2154
    desc_col_width=$((TERM_WIDTH - cmd_col_width - 3))

    for cmd in $cmds; do
        printf "  %-${cmd_col_width}s" "$cmd"
        line_index=0
        while IFS= read -r line; do
            if [[ line_index -eq 0 ]]; then
                printf "%s\n" "$line"
            else
                printf "%17s%s\n" " " "$line"
            fi
            ((line_index++))
        done <<< "$( _meta_command_get "$cmd" "description" | fmt --width="$desc_col_width" )"
    done
}

_help_options () {
    local desc_offset options usages descs usage

    desc_offset=10
    options=$(_opt_get_all)
    usages=()
    descs=()

    if ! util_in_array "help" "$options"; then
        usages+=("  --help | -h")
        descs+=("Show this help.")
    fi

    for option in $options; do
        usage="$(printf "  --%s | -%s" "$option" "$(_opt_get_param "$option" "short")")"
        if [[ -z "$(_opt_get_param "$option" "value")" ]]; then
            usage="$usage [$(_opt_get_param "$option" "variable" | awk '{print toupper($0)}')]"
        fi
        usages+=("$usage")
        descs+=("$(_opt_get_param "$option" "desc" | fmt --width=$((TERM_WIDTH - desc_offset)))")
    done

    for ((i=0; i<${#usages[@]}; i++)); do
        printf "%s\n" "${usages[i]}"
        while IFS= read -r line; do
            printf "%${desc_offset}s%s\n" " " "${line}"
        done <<< "${descs[i]}"
        echo
    done
}
