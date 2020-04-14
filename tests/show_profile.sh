#!/bin/bash
#
# Display a profile nicely
#
# Usage : paste profile.{tim,log} | xargs show_profile.sh
#

# shellcheck disable=2016
paste "$1" "$2" | awk '
{
  if (length(prev_line) > 0) {
    printf("%8f %s\n", $1-prev_time, prev_line)
    sum+=$1-prev_time
  }
  prev_time=$1
  prev_line=$0
}

END { printf("Total execution time : %f\n", sum) }
'
