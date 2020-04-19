#!/usr/bin/env bash
set -euo pipefail

util_in_array () {

    search="$1";
    shift;

    for item in "$@"; do
        if [[ "$item" == "$search" ]]; then
            return 0;
        fi
    done

    return 1
}

util_fmt () {

    fold -s -w "$1"
}

util_trace () {
    local i

    i=0
    unset "FUNCNAME[0]"
    for func in "${FUNCNAME[@]}"; do
        printf '%20s() %s:%d\n' "$func" "${BASH_SOURCE[$i+1]}" "${BASH_LINENO[$i]}"
        (( ++i ))
    done

    exit 1
}

util_dbg () {

    unset _SILENT
    printf "in %s : %s\n" "${FUNCNAME[1]}" "$1" >&2
}
