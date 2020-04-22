#!/usr/bin/env bash
set -euo pipefail

_help_print_main() {

    _help_summary
    _help_usage
    _help_description
    _help_commands
    _help_options
}

_help_print_subcommand () {

    _help_summary "$1"
    _help_usage "$1"
    _help_description "$1"
    _help_options "$1"
}

_help_print_version () {

    printf '%s %s\n' "$SCRIPT_FILE" "$(meta_get "version")"
}

_help_summary () {

    meta_get "summary" "${1-}" | util_fmt "$TERM_WIDTH"
}

_help_usage () {
    local usage argument

    printf '\n\nUsage : '

    if [[ -z "${1-}" ]]; then
        if [[ -n "${usage:="$(meta_get "usage")"}" ]]; then
            printf '%s' "$usage"
        else
            if [[ -n "${argument:="$(meta_get "argument")"}" ]]; then
                printf '%s [OPTIONS] [%s]' \
                       "$SCRIPT_FILE" \
                       "$(echo "$argument" | tr '[:lower:]' '[:upper:]')"
            else
                printf '%s [OPTIONS]' "$SCRIPT_FILE"
            fi
        fi
    else
        if [[ -n "${usage:="$(meta_get "usage" "$1")"}" ]]; then
            printf "%s" "$usage"
        elif [[ "${CMD}" == "help" ]]; then
            printf "%s %s [OPTIONS]" "$SCRIPT_FILE" "${CMD_ARGS[0]}"
        else
            if [[ -n "${argument:="$(meta_get "argument" "${CMD}")"}" ]]; then
                printf "%s %s [OPTIONS] [%s]" \
                       "$SCRIPT_FILE" \
                       "${CMD}" \
                       "$(echo "$argument" | tr '[:lower:]' '[:upper:]')"
            else
                printf "%s %s [OPTIONS]" "$SCRIPT_FILE" "${CMD}"
            fi
        fi
    fi
}

_help_description () {
    local description

    if [[ -n "${description:="$(meta_get "description" "${1:-}")"}" ]]; then
        printf '\n\n'
        printf "%s" "$description" | util_fmt "$TERM_WIDTH"
    fi
}

_help_commands () {
    local cmds max_cmd_length line_index

    cmds=$(_cmd_get_all)

    # if there's no commands, don't show anything.
    if [[ "$cmds" == "" ]]; then
        return
    fi

    max_cmd_length=0
    for cmd in $cmds; do
        if [[ ${#cmd} -gt $max_cmd_length ]]; then
            max_cmd_length=${#cmd}
        fi
    done

    cmd_col_width=$((max_cmd_length + 1))
    desc_col_width=$((TERM_WIDTH - cmd_col_width - 3))

    printf '\n\nCommands :\n'

    for cmd in $cmds; do
        printf "\n  %-${cmd_col_width}s " "$cmd"
        line_index=0
        while read -r line; do
            if [[ line_index -eq 0 ]]; then
                printf "%s" "$line"
            else
                printf "\n%$((cmd_col_width + 3))s%s" " " "$line"
            fi
            line_index=$((line_index + 1))
        done <<< "$( meta_get "summary" "$cmd" | util_fmt "$desc_col_width" )"
    done
}

_help_options () {
    local desc_offset descs short subcmd type usage usages value variable

    subcmd="${1:-}"
    desc_offset=10
    usages=()
    descs=()

    if [[ -z "${_OPTIONS+x}" ]]; then
        _OPTIONS=()
    fi

    if [[ ${#_OPTIONS[@]} -gt 0 ]]; then
        for option in "${_OPTIONS[@]}"; do

            short="$(_meta_get_opt "$option" "short" "$subcmd")"
            variable="$(_meta_get_opt "$option" "variable" "$subcmd")"
            value="$(_meta_get_opt "$option" "value" "$subcmd")"
            type=$(_meta_get_opt "$option" "type" "$subcmd")

            if [[ -z "$short" ]]; then
                usage="  --$option"
            else
                usage="  --$option | -$short"
            fi

            if [[ -z "$value" ]]; then
                usage="$usage [$(echo "$variable" | tr '[:lower:]' '[:upper:]')]"
            elif [[ "$type" == "option" ]]; then
                usage="$usage ($(echo "$variable" | tr '[:lower:]' '[:upper:]'))"
            fi

            usages+=("$usage")
            descs+=("$(_meta_get_opt "$option" "desc" "$subcmd" | util_fmt $((TERM_WIDTH - desc_offset)))")

            unset short variable value type
        done
    fi

    if [[ "${#usages[@]}" -gt 0 ]]; then
        printf '\n\nOptions :\n'
    fi

    for ((i=0; i<${#usages[@]}; i++)); do
        printf "\n%s" "${usages[i]}"
        while read -r line; do
            printf "\n%${desc_offset}s%s" " " "${line}"
        done <<< "${descs[i]}"
        echo
    done
}
