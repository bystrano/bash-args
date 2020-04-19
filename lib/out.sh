#!/usr/bin/env bash
set -euo pipefail

_out_tput () {
    if [[ -x $(command -v tput) ]]; then
        tput "$@"
    fi
}
out_usage_error () {

    if [[ -z "${_SILENT-}" ]]; then
        # text in yellow
        echo "$(_out_tput setaf 3)$1$(_out_tput sgr 0)" 1>&2;
    fi
    exit 2;
}

out_fatal_error () {

    if [[ -z "${_SILENT-}" ]]; then
        # text in read
        echo "$(_out_tput setaf 1)$1$(_out_tput sgr 0)" 1>&2;
    fi
    exit 1;
}
