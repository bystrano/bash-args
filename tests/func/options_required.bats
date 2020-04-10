#!/usr/bin/env bats

NAME="options required:"
SCRIPT=tests/fixtures/options_required.sh

load ../helper

@test "$NAME do help" {
    run bash "$SCRIPT" --help
    expected=$(cat << EOF
A simple script that takes some options but no subcommands.

Usage : options_required.sh [OPTIONS]

Options :

  --help | -h
          Show this help.

  --req-req | -R [REQ_REQ]
          A required option that requires an argument.

  --req-opt | -r (REQ_OPT)
          A required option that may take an argument.
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME req-req - cannot be omitted" {
    run bash "$SCRIPT"
    assert_equals "$status" 2
    assert_equals "$output" "$(usage_error_format "The --req-req option is required.")"
}

@test "$NAME req-req - argument cannot be omitted" {
    run bash "$SCRIPT" --req-req
    assert_equals "$status" 2
    assert_equals "$output" "$(usage_error_format "The --req-req option requires an argument.")"
}

@test "$NAME req-req - argument can be set" {
    run grep req-req < <(bash "$SCRIPT" --req-req test --req-opt)
    assert_equals "$status" 0
    assert_equals "$output" "req-req: test"
}

@test "$NAME req-opt - cannot be omitted" {
    run bash "$SCRIPT" --req-req _
    assert_equals "$status" 2
    assert_equals "$output" "$(usage_error_format "The --req-opt option is required.")"
}

@test "$NAME req-opt - argument can be omitted" {
    run grep req-opt < <(bash "$SCRIPT" --req-req _ --req-opt)
    assert_equals "$status" 0
    assert_equals "$output" "req-opt: opt_value"
}

@test "$NAME req-opt - argument can be set" {
    run grep req-opt < <(bash "$SCRIPT" --req-req _ --req-opt test)
    assert_equals "$status" 0
    assert_equals "$output" "req-opt: test"
}
