#!/bin/bash
#
# Description : A simple script for testing the argument parsing code.
#
# Options :
#
# %% first
# desc="An optional option that may take an argument."
# short="f" type="option" variable="opt_req" value="opt_value" default="opt_default"
#
# %% second
# desc="An optional option that may take an argument."
# short="s" type="option" variable="opt_opt" value="opt_value" default="opt_default"
#
set -euo pipefail

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh

for opt in "${CMD_OPTS[@]}"; do
    printf "%s\n" "$opt"
done
