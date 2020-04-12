#!/usr/bin/awk


BEGIN {
    IGNORE_CASE=1
    stop=0
}

# stop on the first line that doesn't start with a #
! /^#/ { stop=1 }

/^# / && stop==0 {
    if (match($0, /^# ([^:]+) ?:/)) {
        current_meta = substr($0, 3, RLENGTH - 3)
        sub(/ +$/, "", current_meta)
        current_meta = tolower(current_meta)

        current_value = substr($0, RLENGTH + 1)
        sub(/^ +/, "", current_value)

        metas[current_meta] = current_value
    } else {
        metas[current_meta] = metas[current_meta] substr($0, 2)
    }
}

END { print metas[meta] }
