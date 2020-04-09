#!/bin/bash
set -euo pipefail

## Variables

# shellcheck disable=SC2034
term_width=${term_width:=80}


read -r _ file < <(caller)
file="$(readlink -f "$file")"

# shellcheck disable=2034
script_file="$(basename "$file")"
# shellcheck disable=2034
script_dir="$(dirname "$file")"
cmd_dir="$(dirname "$(readlink -f "$0")")"

# charger les fichiers du dossier lib/
# shellcheck source=/dev/null
. <(cat "${cmd_dir}"/lib/*.sh)

# shellcheck disable=SC2068
opt_parse $@
