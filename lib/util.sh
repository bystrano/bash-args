#!/bin/bash
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

    if [[ -x "$(command -v fmt)" ]]; then
        fmt --width="$1"
    else
        fold --spaces --width="$1"
    fi
}
