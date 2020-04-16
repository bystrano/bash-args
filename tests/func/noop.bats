#!/usr/bin/env bats

NAME="no options:"
SCRIPT=tests/fixtures/noop.sh

load ../helper

@test "$NAME do no harm" {
    run bash "$SCRIPT"
    assert_equals "$output" "done"
}

@test "$NAME do help" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.

Usage : noop.sh [OPTIONS]

This is a long description of the commands. This is not necessary here because 
this command is so simple, but we need an example.

Options :

  --help | -h
          Show this help.
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME do help (short)" {
    run bash "$SCRIPT" -h
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.

Usage : noop.sh [OPTIONS]

This is a long description of the commands. This is not necessary here because 
this command is so simple, but we need an example.

Options :

  --help | -h
          Show this help.
EOF
)
    assert_equals "$output" "$expected"
}
