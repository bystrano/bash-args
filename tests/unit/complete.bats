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
