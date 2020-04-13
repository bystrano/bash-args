#!/usr/bin/env bash
set -euo pipefail

## Variables

TERM_WIDTH=${TERM_WIDTH:=80}
CMDS_DIR=${CMDS_DIR:=cmd}

read -r _ _file < <(caller)
_file="$(readlink -f "$_file")"

# shellcheck disable=2034
SCRIPT_FILE="$(basename "$_file")"
# shellcheck disable=2034
SCRIPT_DIR="$(dirname "$_file")"
CMD_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# charger les fichiers du dossier lib/
for _file in "${CMD_DIR}"/lib/*.sh; do
    # shellcheck source=/dev/null
    . "$_file"
done

# shellcheck disable=SC2068
_opt_parse "$@"

if [[ "${CMD:=}" == "_complete" ]]; then
    _complete
    exit 0
elif [[ "${CMD:=}" == "_register_autocomplete" ]]; then
    printf "complete -C \"%s _complete\" %s\n" "$SCRIPT_FILE" "$SCRIPT_FILE"
    exit 0
fi
