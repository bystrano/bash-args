#!/bin/bash
# Description : A subcommand that prints its options.
set -euo pipefail

# shellcheck disable=2154
printf "my_option: %s\n" "$opt"
