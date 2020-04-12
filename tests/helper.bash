#!/usr/bin/env bash

assert_equals() {

    diff <(echo "$1") <(echo "$2");
    [ "$1" == "$2" ]
}

usage_error_format() {

    if [[ -n "$(which tput)" ]]; then
        printf "%s%s%s" "$(tput setaf 3)" "$1" "$(tput sgr 0)"
    else
        printf "%s" "$1"
    fi
}
