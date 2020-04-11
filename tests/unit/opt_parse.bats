#!/usr/bin/env bats

NAME="opt_parse:"
SCRIPT=tests/fixtures/cmd_opts.sh

load ../helper

@test "$NAME simple option arguments" {
    run bash "$SCRIPT" --first "hello" --second "world"
    expected=$(cat << EOF
--first hello
--second world
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME argument with a space in simple quote" {
    run bash "$SCRIPT" --first 'hello world'
    assert_equals "$output" "--first hello world"
}

@test "$NAME argument with spaces in double quote" {
    run bash "$SCRIPT" --first "hello '\"' world"
    assert_equals "$output" "--first hello '\"' world"
}

@test "$NAME grouped short options" {
    run bash "$SCRIPT" -fs
    expected=$(cat << EOF
--first
--second
EOF
)
    assert_equals "$output" "$expected"
}

@test "$NAME grouped short options with argument" {
    run bash "$SCRIPT" -fs test
    expected=$(cat << EOF
--first
--second test
EOF
            )
    assert_equals "$output" "$expected"
}
