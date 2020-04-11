#!/bin/bash
set -euo pipefail

## Variables

# shellcheck disable=SC2034
TERM_WIDTH=${TERM_WIDTH:=80}


read -r _ _file < <(caller)
_file="$(readlink -f "$_file")"

# shellcheck disable=2034
SCRIPT_FILE="$(basename "$_file")"
# shellcheck disable=2034
SCRIPT_DIR="$(dirname "$_file")"
CMD_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# charger les fichiers du dossier lib/
# shellcheck source=/dev/null
. <(cat "${CMD_DIR}"/lib/*.sh)

# shellcheck disable=SC2068
_opt_parse "$@"
