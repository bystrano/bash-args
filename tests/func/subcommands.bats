#!/usr/bin/env bats

NAME="subcommands:"
SCRIPT=tests/fixtures/subcommands.sh

load ../helper

@test "$NAME do no harm" {
    run bash "$SCRIPT" subcommand1
    expected=$(cat << EOF
my_option: opt_default
flag: 0
opt-req: opt_default
opt-opt: opt_default
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

  subcommand1  A subcommand that prints its options.
  subcommand2  A subcommand that does nothing.

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

    run bash "$SCRIPT" -o test subcommand1 --flag --opt-opt --opt-req opt_value
    expected=$(cat << EOF
my_option: test
flag: 1
opt-req: opt_value
opt-opt: opt_value
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME subcommand help" {

    run bash "$SCRIPT" help subcommand1
    . lib/util.sh
    expected=$(util_fmt 80 << EOF
A subcommand that prints its options.

Usage : subcommands.sh subcommand1 [OPTIONS]

If there was something to say about this subcommand, this would be a great place. You could go on and on in a long description of the use cases and show how to achieve great things by typing commands in a terminal.

Options :

  --help | -h
          Show this help.

  --flag
          An option meant to be used as a flag.

  --opt-req [OPT_REQ]
          An optional option that requires a argument.

  --opt-opt (OPT_OPT)
          An optional option that may take a argument.

  --opt | -o [MY_OPTION]
          An option that requires a argument.
EOF
            )
    assert_equals "$output" "$expected"

    run bash "$SCRIPT" -h subcommand1
    assert_equals "$output" "$expected"
    run bash "$SCRIPT" subcommand1 --help
    assert_equals "$output" "$expected"
}
