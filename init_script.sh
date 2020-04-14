#!/usr/bin/env bash
set -euo pipefail


####
## User Variables

TERM_WIDTH=${TERM_WIDTH:=80}
CMDS_DIR=${CMDS_DIR:=cmd}


####
## Computed Variables

read -r _ _file < <(caller)
_file="$(readlink -f "$_file")"

# shellcheck disable=2034
SCRIPT_FILE="$(basename "$_file")"
# shellcheck disable=2034
SCRIPT_DIR="$(dirname "$_file")"
CMD_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"


####
## Load the lib/ files

for _file in "${CMD_DIR}"/lib/*.sh; do
    # shellcheck source=/dev/null
    . "$_file"
done


####
## Parse the arguments

_opt_parse "$@"
