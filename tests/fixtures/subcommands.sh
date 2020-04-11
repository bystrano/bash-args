#!/bin/bash
#
# Description : A simple script that has subcommands.
#
# Options :
#
# %% opt
# desc="An option that requires a argument."
# short="o" type="option" variable="opt" default="opt_default"
#
set -euo pipefail

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh

cmds_do_subcommand
