#!/usr/bin/awk


BEGIN {
    IGNORECASE=1
    stop=0
}

# stop on the first line that doesn't start with a #
! /^#/ { stop=1 }

/^# / && stop==0 {
    if (match($0, /^# ([^:]+) : ?(.*)$/, matches)) {
        current_meta = tolower(matches[1])
        metas[current_meta] = matches[2]
    } else {
        metas[current_meta] = metas[current_meta] substr($0, 2)
    }
}

END { print metas[meta] }
