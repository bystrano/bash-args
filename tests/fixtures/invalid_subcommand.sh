#!/usr/bin/env bash
#
# Summary : A simple script that takes an option, and a subcommand that has a duplicate option.
#
# Options :
#
# % flag
# desc="An option meant to be used as a flag."
# short="f" type="flag" variable="flag" value="1" default=0
#
set -euo pipefail

# shellcheck disable=2034
CMDS_DIR=cmd_invalid

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init.sh
