#!/bin/bash
set -euo pipefail

_spip_get_root () {
    local spip_root cwd

    spip_root='';

    cwd=$( pwd );
    while [[ $( pwd ) != '/' ]]; do
        if [[ -f 'ecrire/inc_version.php' ]]; then
            spip_root=$( pwd );
            break;
        fi
        cd ..;
    done;
    cd "$cwd";

    if [[ -z "$spip_root" ]]; then
        out_fatal_error "ecrire/inc_version.php introuvable. Ce script doit être exécuté dans l'arborescence d'un site SPIP."
    fi;

    echo "$spip_root";
}

_spip_get_env () {

    spip_root=$( _spip_get_root );

    # On se place à la racine du SPIP si c'est possible, on annule tout sinon.
    if [[ -z "$spip_root" ]]; then
        exit 1;
    else
        cd "$spip_root" || exit 1;
    fi;

    # charger des variables d'environnement dans un fichier .env
    if [ -r .env ]; then
        # shellcheck source=/dev/null
        source .env
    elif [ -r .env.gpg ]; then
        eval "$(gpg -d .env.gpg 2> /dev/null)"
    fi

    # charger les accès à la DB depuis config/connect.php
    # shellcheck disable=2154
    if [[ -f "config/${connect}.php" ]]; then

        # shellcheck disable=SC2034
        IFS=',' read -r db_host db_port db_user db_pwd db_name _ db_prefix _ <<< \
             $( grep spip_connect_db "config/${connect}.php"\
                    | sed 's/^spip_connect_db(//'\
                    | sed -E "s/[^']*'([^']*)'?/\1,/g"\
                    | sed "s/);//"\
                    | head --lines=1 );

        if [[ -z "$db_port" ]]; then
            db_port=3306; # use default
        fi;
    else
        out_fatal_error "Le fichier config/${connect}.php n'existe pas, est-ce que ce SPIP est bien installé ?";
    fi

    # charger les accès au ftp de prod depuis la config de git
    if [[ -z ${ftp_user+x} ]]; then
        ftp_user="$( git config --get git-ftp.user || echo '' )";
    fi;
    if [[ -z ${ftp_pwd+x} ]]; then
        ftp_pwd="$( git config --get git-ftp.password || echo '' )";
    fi;
    if [[ -z ${ftp_url+x} ]]; then
        ftp_url="$( git config --get git-ftp.url || echo '' )";
    fi;
}
