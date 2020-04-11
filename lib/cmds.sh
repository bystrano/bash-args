#!/bin/bash
set -euo pipefail

_cmds_is_registered () {

    if [[ -f "${SCRIPT_DIR}/${CMDS_DIR}/${1}.sh" ]]; then
        return 0
    else
        return 1
    fi
}

_cmds_get_commands () {

    if [[ -d "${SCRIPT_DIR}/${CMDS_DIR}" ]]; then
        find "${SCRIPT_DIR}/${CMDS_DIR}/" -type f -name '*.sh' -print | sort \
            | sed 's#.*/\([^/]*\)\.sh#\1#' \
            | xargs printf '%s '
    fi
}
