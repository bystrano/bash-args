#!/usr/bin/env bats

NAME="invalid:"
SCRIPT=tests/fixtures/invalid_subcommand.sh

load ../helper

@test "$NAME invalid subcommand ok when not used" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that takes an option, and a subcommand that has a duplicate 
option.

Usage : invalid_subcommand.sh [OPTIONS]

Commands :

  help  Show help about subcommands.
  cmd   A subcommand that has a option already defined in the main script,
        which is invalid.

Options :

  --help | -h
          Show this help.

  --flag | -f
          An option meant to be used as a flag.
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME invalid subcommand not ok when used" {
    run bash "$SCRIPT" cmd -h
    assert_equals "$status" 1
    assert_equals "$output" "$(fatal_error_format "duplicate option definitions : flag")"
}
