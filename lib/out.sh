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

out_exec () {

    # the summary in green
    if [[ -n "$1" ]]; then
        echo "$(_out_tput setaf 2)# $1$(_out_tput sgr 0)"
    fi
    shift
    if [[ ${dry_run:-0} -ne 1 ]]; then
        # the command in blue
        echo "$(_out_tput setaf 4)> $*$(_out_tput sgr 0)"
        # execute the command
        eval "$*"
    else
        # the command in dimmed blue
        echo "$(_out_tput dim)$(_out_tput setaf 4)> $*$(_out_tput sgr 0)"
    fi
}
