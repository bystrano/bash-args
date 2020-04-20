#!/usr/bin/env bash
#
# Summary : A simple script that takes some options but no subcommands.
#
# Options :
#
# % flag
# desc="An option meant to be used as a flag."
# short="f" type="flag" variable="flag" value="1" default=0
#
# % opt-req
# desc="An optional option that requires a argument." argument_complete=number
# short="O" type="option" variable="opt_req" default="opt_default"
#
# % opt-opt
# desc="An optional option that may take a argument. And has a nasty % character in its description."
# short="o" type="option" variable="opt_opt" value="opt_value" default="opt_default"
#
# Argument complete : directory
#
set -euo pipefail

# ignore the subcommands
# shellcheck disable=2034
CMDS_DIR=_

# a auto-complete function for the opt option
_complete_number () {

    COMP_REPLIES+=("one")
    COMP_REPLIES+=("two")
    COMP_REPLIES+=("three")
}

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh


printf "flag: %s\n" "${flag:=}"
printf "opt-req: %s\n" "${opt_req:=}"
printf "opt-opt: %s\n" "${opt_opt:=}"

# shellcheck disable=2016
printf '$1: %s\n' "${1-}"
# shellcheck disable=2016
printf '$2: %s\n' "${2-}"
# shellcheck disable=2016
printf '$3: %s\n' "${3-}"
