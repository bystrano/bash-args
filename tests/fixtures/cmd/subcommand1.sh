#!/usr/bin/env bash
#
# Summary : A subcommand that prints its options.
#
# Description : If there was something to say about this subcommand, this would
# be a great place. You could go on and on in a long description of the use
# cases and show how to achieve great things by typing commands in a terminal.
#
set -euo pipefail

# shellcheck disable=2154
printf "my_option: %s\n" "$my_option"
