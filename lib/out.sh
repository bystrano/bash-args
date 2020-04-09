#!/bin/bash
set -euo pipefail

out_usage_error () {

    # texte en jaune
    echo "$(tput setaf 3)$1$(tput sgr 0)" 1>&2;
    exit 2;
}

out_fatal_error () {

    # texte en rouge
    echo "$(tput setaf 1)$1$(tput sgr 0)" 1>&2;
    exit 1;
}

out_exec () {

    # la description en vert s'il y en a une
    if [[ -n "$1" ]]; then
        echo "$(tput setaf 2)# $1$(tput sgr 0)"
    fi
    shift
    if [[ ${dry_run:-0} -ne 1 ]]; then
        # la commande en bleu
        echo "$(tput setaf 4)> $*$(tput sgr 0)"
        # exécuter la commande
        eval "$*"
    else
        # la commande en bleu dimmé
        echo "$(tput dim)$(tput setaf 4)> $*$(tput sgr 0)"
    fi
}
