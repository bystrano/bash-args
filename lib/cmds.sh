#!/usr/bin/env bash
set -euo pipefail

_cmds_get_commands () {
    local file cmd

    printf 'help '
    if [[ -d "${SCRIPT_DIR}/${CMDS_DIR}" ]]; then
        for file in "$SCRIPT_DIR"/"$CMDS_DIR"/*.sh; do
            file=$(basename "$file")
            cmd="${file:0:${#file}-3}"
            if [[ "$cmd" != "help" ]]; then
                printf '%s ' "$cmd"
            fi
        done
    fi
}

cmds_do_subcommand () {

    if [[ -f "${cmd_file:=${SCRIPT_DIR}/${CMDS_DIR}/${CMD:=help}.sh}" ]]; then
        # shellcheck source=/dev/null
        . "$cmd_file"
    elif [[ "$CMD" == "help" ]]; then
        if [[ ${#CMD_ARGS[@]} -eq 0 ]]; then
            _help_print_main
        else
            _meta_get_all_opts "${CMD_ARGS[@]}"
            _help_print_subcommand "${CMD_ARGS[0]}"
        fi
    else
        out_usage_error "Invalid command : $CMD"
    fi
}
