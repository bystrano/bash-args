#!/usr/bin/env bats

NAME="complete:"
SCRIPT_SUBCMD=tests/fixtures/subcommands.sh
SCRIPT_OPTIONS=tests/fixtures/options.sh

load ../helper

@test "$NAME complete commands" {
    export COMP_LINE="subcommand.sh "
    run ${SCRIPT_SUBCMD} _complete
    expected=$(cat << EOF
help
subcommand1
subcommand2
zubcommand-dash
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME complete long options" {
    export COMP_LINE="options.sh -"
    run ${SCRIPT_OPTIONS} _complete
    expected=$(cat << EOF
-h
--help
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

@test "$NAME complete command options when a subcommand is already input" {

    export COMP_LINE="subcommands.sh -"
    run ${SCRIPT_SUBCMD} _complete
    expected=$(cat << EOF
-h
--help
-o
--opt
EOF
            )
    assert_equals "$output" "$expected"

    export COMP_LINE="subcommands.sh subcommand1 -"
    run ${SCRIPT_SUBCMD} _complete
    expected=$(cat << EOF
-h
--help
-f
--flag
-r
--opt-req
--opt-opt
-o
--opt
EOF
            )
    assert_equals "$output" "$expected"
}
