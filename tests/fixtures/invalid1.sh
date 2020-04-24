#!/usr/bin/env bash
#
# Summary : A simple script that takes some options but no subcommands.
#
# Options :
#
# % invalid-option
# desc="An option that misses a variable parameter."
# short="f" type="flag" value="1" default=0
set -euo pipefail

# ignore the subcommands
# shellcheck disable=2034
CMDS_DIR=_

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init.sh

echo "done"
