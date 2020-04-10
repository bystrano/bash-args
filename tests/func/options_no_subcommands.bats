#!/usr/bin/env bats

NAME="options - no subcommands : "
SCRIPT=tests/fixtures/options_no_subcommands.sh

load ../helper

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
    assert_equals "$output" "$expected"
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
    assert_equals "$output" "$expected"
}

@test "$NAME flag -- can be omitted" {
    run grep flag < <(bash "$SCRIPT")
    assert_equals "$status" 0
    assert_equals "$output" "flag: 0"
}

@test "$NAME flag -- can be used" {
    run grep flag < <(bash "$SCRIPT" --flag)
    assert_equals "$status" 0
    assert_equals "$output" "flag: 1"
}

@test "$NAME opt-req -- can be omitted" {
    run grep opt-req < <(bash "$SCRIPT")
    assert_equals "$status" 0
    assert_equals "$output" "opt-req: opt_default"
}

@test "$NAME opt-req -- argument cannot be omitted" {
    run bash "$SCRIPT" --opt-req
    assert_equals "$status" 2
    assert_equals "$output" "$(usage_error_format "The --opt-req option requires an argument.")"
}

@test "$NAME opt-req -- argument can be set" {
    run grep opt-req < <(bash "$SCRIPT" --opt-req test)
    assert_equals "$status" 0
    assert_equals "$output" "opt-req: test"
}
