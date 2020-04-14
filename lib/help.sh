#!/usr/bin/env bash
set -euo pipefail

_help_print_main() {
    local help summary usage description cmds opts file

    if [[ -n "${summary:="$(_help_summary)"}" ]]; then
        printf -v help "%s" "$summary"
    fi

    if [[ -n "${usage:="$(_help_usage)"}" ]]; then
        printf -v help "%s\n\nUsage : %s" "${help:=}" "$usage"
    fi

    if [[ -n "${description:="$(_help_description)"}" ]]; then
        printf -v help "%s\n\n%s" "${help:=}" "$description"
    fi

    if [[ -n "${cmds:="$(_help_commands)"}" ]]; then
        printf -v help "%s\n\nCommands :\n\n%s" "${help:=}" "$cmds"
    fi

    if [[ -n "${opts:="$(_help_options)"}" ]]; then
        printf -v help "%s\n\nOptions :\n\n%s" "${help:=}" "$opts"
    fi

    printf "%s\n" "${help:=}"
}

_help_print_subcommand () {

    local help summary usage description cmds opts file

    if [[ -n "${summary:="$(_help_summary "$1")"}" ]]; then
        printf -v help "%s" "$summary"
    fi

    if [[ -n "${usage:="$(_help_usage_subcommand "$1")"}" ]]; then
        printf -v help "%s\n\nUsage : %s" "${help:=}" "$usage"
    fi

    if [[ -n "${description:="$(_help_description "$1")"}" ]]; then
        printf -v help "%s\n\n%s" "${help:=}" "$description"
    fi

    if [[ -n "${opts:="$(_help_options_subcommand "$1")"}" ]]; then
        printf -v help "%s\n\nOptions :\n\n%s" "${help:=}" "$opts"
    fi

    printf "%s\n" "${help:=}"
}

_help_summary () {
    local file summary

    if [[ -n "${summary:="$(_meta_get "summary" "${1:-}" | util_fmt "${TERM_WIDTH}")"}" ]]; then
        printf "%s" "$summary"
    fi
}

_help_usage () {
    local usage

    if [[ -n "${usage:="$(_meta_get "usage")"}" ]]; then
        printf "%s" "$usage"
    else
        printf "%s [OPTIONS]" "$SCRIPT_FILE"
    fi
}

_help_usage_subcommand () {

    if [[ -n "${usage:="$(_meta_get "usage" "$1")"}" ]]; then
        printf "%s" "$usage"
    elif [[ "${CMD}" == "help" ]]; then
        printf "%s %s [OPTIONS]" "$SCRIPT_FILE" "${CMD_ARGS[0]}"
    else
        printf "%s %s [OPTIONS]" "$SCRIPT_FILE" "${CMD}"
    fi
}

_help_description () {
    local description

    if [[ -n "${description:="$(_meta_get "description" "${1:-}" | util_fmt "${TERM_WIDTH}")"}" ]]; then
        printf "%s" "$description"
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
    desc_col_width=$((TERM_WIDTH - cmd_col_width - 3))

    for cmd in $cmds; do
        printf "  %-${cmd_col_width}s " "$cmd"
        line_index=0
        while IFS= read -r line; do
            if [[ line_index -eq 0 ]]; then
                printf "%s\n" "$line"
            else
                printf "%18s%s\n" " " "$line"
            fi
            ((line_index++))
        done <<< "$( _meta_get "summary" "$cmd" | util_fmt "$desc_col_width" )"
    done
}

_help_options () {
    local subcmd desc_offset options usages descs usage

    subcmd="${1:-}"
    desc_offset=10
    options=$(_meta_get_all_opts "$subcmd")
    usages=()
    descs=()

    if ! util_in_array "help" "$options" && [[ -z "${2+x}" ]]; then
        usages+=("  --help | -h")
        descs+=("Show this help.")
    fi

    for option in $options; do
        local short

        short="$(_meta_get_opt "$option" "short" "$subcmd")"
        if [[ -z "$short" ]]; then
            usage="$(printf "  --%s" "$option")"
        else
            usage="$(printf "  --%s | -%s" "$option" "$short")"
        fi
        if [[ -z "$(_meta_get_opt "$option" "value" "$subcmd")" ]]; then
            usage="$usage [$(_meta_get_opt "$option" "variable" "$subcmd" | awk '{print toupper($0)}')]"
        elif [[ "$(_meta_get_opt "$option" "type" "$subcmd")" == "option" ]]; then
            usage="$usage ($(_meta_get_opt "$option" "variable" "$subcmd" | awk '{print toupper($0)}'))"
        fi
        usages+=("$usage")
        descs+=("$(_meta_get_opt "$option" "desc" "$subcmd" | util_fmt $((TERM_WIDTH - desc_offset)))")
    done

    for ((i=0; i<${#usages[@]}; i++)); do
        printf "%s\n" "${usages[i]}"
        while IFS= read -r line; do
            printf "%${desc_offset}s%s\n" " " "${line}"
        done <<< "${descs[i]}"
        echo
    done
}

_help_options_subcommand () {

    _help_options "$1"
}
