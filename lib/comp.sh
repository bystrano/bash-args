#!/usr/bin/env bash
set -euo pipefail

_complete () {
    local cur

    # shellcheck disable=2086
    _opt_parse $COMP_LINE

    if [[ "${COMP_LINE:(-1)}" == " " ]]; then
        cur=''
    else
        cur="${_ARGS[((${#_ARGS[@]}-1))]}"
    fi

    compgen -W "item1 item2" -- "${cur}"
    exit;
}
