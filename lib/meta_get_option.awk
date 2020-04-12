#!/usr/bin/awk

BEGIN { RS="%% " }

/[^[:blank:]]/ {
    if ($1 == option) {
        cmd = substr($0, length($1)+2) sprintf("\n echo -n $%s", param)
        if ((cmd | getline result) > 0) {
            printf "%s", result
        }
    }
}
