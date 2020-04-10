#!/bin/bash
#
# Description : A simple script that takes some options but no subcommands.
#
# Options :
#
# %% flag
# desc="An option meant to be used as a flag."
# short="f" type="flag" variable="flag" value="1" default=0
#
# %% opt-req
# desc="An optional option that requires a argument."
# short="O" type="option" variable="opt_req" default="opt_default"
#
# %% opt-opt
# desc="An optional option that may take a argument."
# short="o" type="option" variable="opt_opt" value="opt_value" default="opt_default"
#
set -euo pipefail

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh


printf "flag: %s\n" "${flag:=}"
printf "opt-req: %s\n" "${opt_req:=}"
printf "opt-opt: %s\n" "${opt_opt:=}"
