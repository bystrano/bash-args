#!/usr/bin/env bats

NAME="complete:"
SCRIPT_OPTS=tests/fixtures/cmd_opts.sh
SCRIPT_ARGS=tests/fixtures/cmd_args.sh

load ../helper

@test "$NAME complete commands" {
    export COMP_LINE="subcommand.sh "
    run tests/fixtures/subcommands.sh _complete
    expected=$(cat << EOF
subcommand1
subcommand2
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME complete long options" {
    export COMP_LINE="options.sh -"
    run tests/fixtures/options.sh _complete
    expected=$(cat << EOF
-f
--flag
-O
--opt-req
-o
--opt-opt
EOF
            )
    assert_equals "$output" "$expected"
}
