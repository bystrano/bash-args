#!/usr/bin/env bash
#
# Summary : A simple script that has subcommands.
#
# Options :
#
# % opt
# desc="An option that requires a argument."
# short="o" type="option" variable="my_option" default="opt_default"
#
set -euo pipefail

if [[ "${_PROFILE:=0}" -eq 1 ]]; then
    mkdir -p tmp
    exec 3>&2 2> >(tee tmp/profile.$$.log |
                       sed -u 's/^.*$/now/' |
                       date -f - +%s.%N >tmp/profile.$$.tim)
    set -x
fi

# shellcheck source=/dev/null
. "$(dirname "$0")"/../../init_script.sh

cmds_do_subcommand
