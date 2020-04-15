#!/usr/bin/env bats

NAME="meta:"
SCRIPT_OPTS=tests/fixtures/cmd_opts.sh
SCRIPT_ARGS=tests/fixtures/cmd_args.sh

load ../helper

@test "$NAME _meta_get" {
    run bash -c ". lib/meta.sh && _meta_get summary _ tests/fixtures/noop.sh"
    expected=$(cat << EOF
A simple script that takes no options nor subcommands.
EOF
            )
    assert_equals "$output" "$expected"

    run bash -c ". lib/meta.sh && _meta_get invalid _ tests/fixtures/noop.sh"
    expected=$(cat << EOF
EOF
            )
    assert_equals "$output" "$expected"

    run bash -c ". lib/meta.sh && _meta_get description _ tests/fixtures/noop.sh"
    expected=$(cat << EOF
This is a long description of the commands. This is not necessary here because this command is so simple, but we need an example.
EOF
            )
    assert_equals "$output" "$expected"
}
