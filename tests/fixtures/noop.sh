#!/bin/bash
#
# Summary : A simple script that takes no options nor subcommands.
#
set -euo pipefail

# ignore the subcommands
# shellcheck disable=2034
CMDS_DIR=_

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh

echo "done"
