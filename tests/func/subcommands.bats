#!/usr/bin/env bats

NAME="subcommands:"
SCRIPT=tests/fixtures/subcommands.sh

load ../helper

@test "$NAME do no harm" {
    run bash "$SCRIPT" subcommand
    expected=$(cat << EOF
my_option: opt_default
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

  subcommand  A subcommand that prints its options.

Options :

  --help | -h
          Show this help.

  --opt | -o [MY_OPTION]
          An option that requires a argument.
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME options' values are passed to the subcommand" {
    run bash "$SCRIPT" -o test subcommand
    expected=$(cat << EOF
my_option: test
EOF
)
    assert_equals "$output" "$expected"
}
