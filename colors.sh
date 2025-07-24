#!/bin/bash
#
# Usage: colors.sh
#
# Prints a test pattern of all 256 terminal colors.
#

set -euo pipefail

i=0
while [ $i -lt 256 ]; do
  printf "\033[48;5;%sm%3d\033[0m " "$i" "$i"
  if [ $(((i + 1) % 16)) -eq 0 ]; then
    echo
  fi
  i=$((i + 1))
done
