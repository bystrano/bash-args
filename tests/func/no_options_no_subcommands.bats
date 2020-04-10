#!/usr/bin/env bats

NAME="no options - no subcommands : "
SCRIPT=tests/fixtures/no_options_no_subcommands.sh

@test "$NAME do no harm" {
    run bash "$SCRIPT"
    [ "$output" = "done" ]
}

@test "$NAME do help" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.

Usage : no_options_no_subcommands.sh [OPTIONS]

Options :

  --help | -h
          Show this help.
EOF
            )
    [ "$output" = "$expected" ]
}

@test "$NAME do help (short)" {
    run bash "$SCRIPT" -h
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.

Usage : no_options_no_subcommands.sh [OPTIONS]

Options :

  --help | -h
          Show this help.
EOF
)
    [ "$output" = "$expected" ]
}
