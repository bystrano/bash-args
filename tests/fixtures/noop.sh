#!/usr/bin/env bash
#
# Summary : A simple script that takes no options nor subcommands.
#
# dEscription: This is a long description of the commands. This is not
# necessary here because this command is so simple, but we need an example.
#
set -euo pipefail

# ignore the subcommands
# shellcheck disable=2034
CMDS_DIR=_

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh

echo "done"
