#!/usr/bin/env bats

NAME="subcommands:"
SCRIPT=tests/fixtures/subcommands.sh

load ../helper

@test "$NAME do no harm" {
    run bash "$SCRIPT" subcommand
    expected=$(cat << EOF
done
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME do help" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that has subcommands.

Usage : subcommands.sh [OPTIONS]

Commands :

  subcommand  A subcommand that just prints "done".

Options :

  --help | -h
          Show this help.
EOF
)
    assert_equals "$output" "$expected"
}
