#!/usr/bin/env bats

@test "do no harm" {
    run bash tests/fixtures/simple_no_options_no_subcommands.sh
    [ "$output" = "done" ]
}
