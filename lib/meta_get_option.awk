#!/usr/bin/awk

BEGIN { RS="%" }

/[^[:blank:]]/ {
    if (all == 1) {
        print $1
    } else {
        if (option == $1) {
            cmd = sprintf("%s\n echo -n $%s", substr($0, length($1) + 2), param)
            if ((cmd | getline result) > 0) {
                printf "%s", result
            }
            close(cmd)
        }
    }
}
