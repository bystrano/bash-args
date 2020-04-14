#!/usr/bin/env bash
#
# Summary : A subcommand that prints its options.
#
# Description : If there was something to say about this subcommand, this would
# be a great place. You could go on and on in a long description of the use
# cases and show how to achieve great things by typing commands in a terminal.
#
# Options:
#
# % flag
# desc="An option meant to be used as a flag."
# type="flag" variable="flag" value="1" default=0
#
# % opt-req
# desc="An optional option that requires a argument."
# type="option" variable="opt_req" default="opt_default"
#
# % opt-opt
# desc="An optional option that may take a argument."
# type="option" variable="opt_opt" value="opt_value" default="opt_default"
#
set -euo pipefail

# shellcheck disable=2154
printf "my_option: %s\n" "$my_option"
printf "flag: %s\n" "${flag:=}"
printf "opt-req: %s\n" "${opt_req:=}"
printf "opt-opt: %s\n" "${opt_opt:=}"
