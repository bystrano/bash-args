#!/usr/bin/env bash
#
# Summary : A simple script for testing the argument parsing code.
#
# Options :
#
# % first
# desc="An optional option that may take an argument." argument_complete=number
# short="f" type="option" variable="opt_req" value="opt_value" default="opt_default"
#
# % second
# desc="An optional option that may take an argument." argument_complete="file"
# short="s" type="option" variable="opt_opt" default="opt_default"
#
set -euo pipefail

# a auto-complete function for the opt option
_complete_number () {

    COMP_REPLIES+=("one")
    COMP_REPLIES+=("two")
    COMP_REPLIES+=("three")
}

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh


printf "cmd: %s\n" "${CMD-}"

for opt in "${CMD_ARGS[@]}"; do
    printf "%s\n" "$opt"
done
