#!/bin/bash
set -euo pipefail

_cmds_is_registered () {

    if [[ -f "${script_dir:?}/cmd/${1}.sh" ]]; then
        return 0
    else
        return 1
    fi
}

_cmds_get_commands () {

    find "${script_dir:?}/cmd/" -type f -name '*.sh' -print | sort \
        | sed 's#.*/\([^/]*\)\.sh#\1#' \
        | xargs printf '%s '
}
