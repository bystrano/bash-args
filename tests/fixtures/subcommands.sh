#!/bin/bash
#
# Description : A simple script that has subcommands.
#
set -euo pipefail

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh

cmds_do_subcommand
