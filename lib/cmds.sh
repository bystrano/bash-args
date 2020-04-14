#!/usr/bin/env bash
set -euo pipefail

_cmds_get_commands () {

    if [[ -d "${SCRIPT_DIR}/${CMDS_DIR}" ]]; then
        find "${SCRIPT_DIR}/${CMDS_DIR}/" -type f -name '*.sh' -print | sort \
            | sed 's#.*/\([^/]*\)\.sh#\1#' \
            | xargs printf '%s '
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
            _help_print_subcommand "${CMD_ARGS[0]}"
        fi
    else
        out_usage_error "Invalid command : $CMD"
    fi
}
