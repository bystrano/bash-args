#!/bin/bash
#
# Summary : A simple script that takes some options but no subcommands.
#
# Options :
#
# % req-req
# desc="A required option that requires an argument."
# short="R" type="option" variable="req_req"
#
# % req-opt
# desc="A required option that may take an argument."
# short="r" type="option" variable="req_opt" value="opt_value"
#
set -euo pipefail

# ignore the subcommands
# shellcheck disable=2034
CMDS_DIR=_

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh


printf "req-req: %s\n" "${req_req:=}"
printf "req-opt: %s\n" "${req_opt:=}"
