#!/bin/bash
#
# Description : A simple script that takes no options nor subcommands.
#
# Usage : my_command
#
set -euo pipefail

# shellcheck source=../../init_script.sh
. "$(dirname "$0")"/../../init_script.sh

echo "done"
