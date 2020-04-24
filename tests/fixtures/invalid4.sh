#!/usr/bin/env bash
#
# Summary : A simple script that takes some options but no subcommands.
#
# Options :
#
# % invalid
# desc="An flag option that misses a default parameter."
# short="f" type="flag" variable=invalid value=0
set -euo pipefail

# ignore the subcommands
# shellcheck disable=2034
CMDS_DIR=_

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init.sh

echo "done"
