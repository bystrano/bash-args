#!/usr/bin/env bats

NAME="options - no subcommands : "
SCRIPT=tests/fixtures/options_no_subcommands.sh

@test "$NAME do no harm" {
    run bash "$SCRIPT"
    expected=$(cat << EOF
flag: 0
opt-req: opt_default
opt-opt: opt_default
req-req: 
req-opt: 
EOF
)
    [ "$output" = "$expected" ]
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

@test "$NAME flag -- can be omitted" {
    run grep flag < <(bash "$SCRIPT")
    [ "$output" = "flag: 0" ]
}

@test "$NAME flag -- can be used" {
    run grep flag < <(bash "$SCRIPT" --flag)
    [ "$output" = "flag: 1" ]
}
