#!/bin/bash
set -euo pipefail

out_usage_error () {

    # text in yellow
    echo "$(tput setaf 3)$1$(tput sgr 0)" 1>&2;
    exit 2;
}

out_fatal_error () {

    # text in read
    echo "$(tput setaf 1)$1$(tput sgr 0)" 1>&2;
    exit 1;
}

out_exec () {

    # the summary in green
    if [[ -n "$1" ]]; then
        echo "$(tput setaf 2)# $1$(tput sgr 0)"
    fi
    shift
    if [[ ${dry_run:-0} -ne 1 ]]; then
        # the command in blue
        echo "$(tput setaf 4)> $*$(tput sgr 0)"
        # execute the command
        eval "$*"
    else
        # the command in dimmed blue
        echo "$(tput dim)$(tput setaf 4)> $*$(tput sgr 0)"
    fi
}
