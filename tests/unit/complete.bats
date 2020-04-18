#!/usr/bin/env bats

NAME="complete:"
SCRIPT_SUBCMD=tests/fixtures/subcommands.sh
SCRIPT_OPTIONS=tests/fixtures/options.sh

load ../helper

@test "$NAME complete commands" {
    export COMP_LINE="subcommands.sh "
    export COMP_POINT=15
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
    export COMP_POINT=13
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
    export COMP_POINT=16
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
    export COMP_POINT=28
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

@test "$NAME complete options before an already input command" {

    export COMP_LINE="subcommands.sh -- subcommand1"
    export COMP_POINT=17
    run $SCRIPT_SUBCMD _complete
    expected=$(cat << EOF
--help
--flag
--opt-req
--opt-opt
--opt
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME don't suggest subcommands when there is already one specified." {

    export COMP_LINE="subcommands.sh subcommand1 "
    export COMP_POINT=27
    run $SCRIPT_SUBCMD _complete
    assert_equals "$output" ""
}

@test "$NAME auto-complete on option arguments - defined by a custom function" {
    export COMP_LINE="subcommands.sh --opt "
    export COMP_POINT=21
    run $SCRIPT_SUBCMD _complete
    expected=$(cat << EOF
help
subcommand1
subcommand2
zubcommand-dash
one
two
three
EOF
            )
    assert_equals "$output" "$expected"

}

@test "$NAME _register_autocomplete" {

    run ${SCRIPT_SUBCMD} _register_autocomplete
    assert_equals "$output" 'complete -C "subcommands.sh _complete" subcommands.sh'
}
