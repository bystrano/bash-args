#!/bin/bash
set -euo pipefail

util_bin_ok () {
    if [[ ! -x $(which "$1") ]]; then
        out_fatal_error "Le programme $1 n'est pas installé.";
    fi
}

util_ssh_exec () {
    util_bin_ok "ssh";

    # shellcheck disable=2154,2029
    ssh "$ssh_user"@"$prod_host" "$1"
}

util_filter_warnings() {

    grep --no-messages --invert-match 'Using a password on the command line interface can be insecure.';
}

# une version de la commande mysql qui ne fait pas de warnings quand on passe le
# mot de passe en option.
util_mysql_quiet () {
    util_bin_ok "mysql";

    mysql "$@" 2> >(util_filter_warnings >&2);
}

# une version de zcat qui sait aussi lire le fichier non-compressés.
util_zcat_or_cat () {

    ( zcat "$1" 2> /dev/null || cat "$1" )
}

util_in_array () {

    search="$1";
    shift;

    for item in "$@"; do
        if [[ "$item" == "$search" ]]; then
            return 0;
        fi
    done

    return 1
}

util_fmt () {

    if [[ -x "$(command -v fmt)" ]]; then
        fmt --width="$1"
    else
        fold --spaces --width="$1"
    fi
}
