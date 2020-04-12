#!/usr/bin/env bash
# Summary : A subcommand that prints its options.
set -euo pipefail

# shellcheck disable=2154
printf "my_option: %s\n" "$my_option"
