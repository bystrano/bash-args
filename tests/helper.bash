#!/bin/bash

assert_equals() {

    diff --side-by-side --color=always <(echo "$1") <(echo "$2");
    [ "$1" == "$2" ]
}

usage_error_format() {

    printf "%s%s%s" "$(tput setaf 3)" "$1" "$(tput sgr 0)"
}
