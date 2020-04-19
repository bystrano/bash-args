#!/usr/bin/awk


BEGIN {
    IGNORE_CASE=1
}

/^# / {
    if (match($0, /^# ([^:]+) ?:/)) {
        current_meta = substr($0, 3, RLENGTH - 3)
        sub(/ +$/, "", current_meta)
        sub(/ /, "_", current_meta)
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

    # replace dashes in the cmd name
    gsub(/-/, "_", cmd)

    printf("export _METAS_%s_ok=1\n", cmd)
    for (var in metas) {
        value = metas[var]
        # trim the value
        sub(/^[ \t\n]+/, "", value)
        sub(/[ \t\n]+$/, "", value)

        # escape the simple quotes
        gsub(/'/, "\\'", value)

        # print the code the export a variable and assign it the value.
        printf("export _METAS_%s_%s=$'%s'\n", cmd, var, value)
    }

    exit;
}
