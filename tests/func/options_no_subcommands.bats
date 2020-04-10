#!/usr/bin/env bats

NAME="options - no subcommands : "
SCRIPT=tests/fixtures/options_no_subcommands.sh

@test "$NAME do no harm" {
    run bash "$SCRIPT"
    [ "$output" = "done" ]
}

@test "$NAME do help" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that takes some options but no subcommands.

Usage : options_no_subcommands.sh [OPTIONS]

Options :

  --help | -h
          Show this help.

  --flag | -f
          An option meant to be used as a flag.

  --opt-req | -O [OPT_REQ]
          An optional option that requires a argument.

  --opt-opt | -o (OPT_OPT)
          An optional option that may take a argument.

  --req-req | -R [REQ_REQ]
          A requiered option that requires an argument.

  --req-opt | -r (REQ_OPT)
          A requiered option that may take an argument.
EOF
            )
    [ "$output" = "$expected" ]
}
