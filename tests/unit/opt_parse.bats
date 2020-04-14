#!/usr/bin/env bats

NAME="opt_parse:"
SCRIPT_OPTS=tests/fixtures/cmd_opts.sh
SCRIPT_ARGS=tests/fixtures/cmd_args.sh

load ../helper

@test "$NAME simple option arguments" {
    run bash "$SCRIPT_OPTS" --first "hello" --second "world"
    expected=$(cat << EOF
--first hello
--second world
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME argument with a space in simple quote" {
    run bash "$SCRIPT_OPTS" --first 'hello world'
    assert_equals "$output" "--first hello world"
}

@test "$NAME argument with spaces in double quote" {
    run bash "$SCRIPT_OPTS" --first "hello '\"' world"
    assert_equals "$output" "--first hello '\"' world"
}

@test "$NAME grouped short options" {
    run bash "$SCRIPT_OPTS" -fs
    expected=$(cat << EOF
--first
--second
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME grouped short options with argument" {
    run bash "$SCRIPT_OPTS" -fs test
    expected=$(cat << EOF
--first
--second test
EOF
            )
    assert_equals "$output" "$expected"
}

@test "$NAME mix arguments and options" {
    run bash "$SCRIPT_ARGS" subcommand1 arg1 --first bla arg2 'hello world' --second blou
    expected=$(cat << EOF
cmd: subcommand1
arg1
arg2
hello world
EOF
            )
    assert_equals "$output" "$expected"

    run bash "$SCRIPT_OPTS" subcommand1 arg1 --first bla arg2 'hello world' --second blou
    expected=$(cat << EOF
--first bla
--second blou
EOF
            )
    assert_equals "$output" "$expected"
}
