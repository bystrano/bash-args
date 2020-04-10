#!/usr/bin/env bats

SCRIPT=tests/fixtures/simple_no_options_no_subcommands.sh

@test "do no harm" {
    run bash "$SCRIPT"
    [ "$output" = "done" ]
}

@test "do help" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.

Usage : simple_no_options_no_subcommands.sh [OPTIONS]

Options :

  --help | -h
          Show this help.
EOF
            )
    [ "$output" = "$expected" ]
}

@test "do help (short)" {
    run bash "$SCRIPT" -h
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.

Usage : simple_no_options_no_subcommands.sh [OPTIONS]

Options :

  --help | -h
          Show this help.
EOF
)
    [ "$output" = "$expected" ]
}
