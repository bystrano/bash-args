#!/usr/bin/awk


BEGIN {
    IGNORE_CASE=1
}

/^# / {
    if (match($0, /^# ([^:]+) ?:/)) {
        current_meta = substr($0, 3, RLENGTH - 3)
        sub(/ +$/, "", current_meta)
        current_meta = tolower(current_meta)

        current_value = substr($0, RLENGTH + 1)
        sub(/^ +/, "", current_value)

        metas[current_meta] = current_value "\n"
    } else {
        metas[current_meta] = metas[current_meta] substr($0, 2) "\n"
    }
}

# stop on the first line that doesn't start with a #
! /^#/ {
    print metas[meta]
    exit;
}
