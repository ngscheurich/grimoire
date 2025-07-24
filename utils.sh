#!/bin/bash
#
# Common utility functions.
#
# Source in other scripts like so:
#     # shellcheck disable=SC1091
#     source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/utils.sh"
#

set -euo pipefail

# Text styles
# RED="\033[31m"
# GREEN="\033[32m"
# YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
# CYAN="\033[36m"
# WHITE="\033[37m"
BOLD="\033[1m"
# UNDERLINE="\033[4m"
# REVERSED="\033[7m"
RESET="\033[0m"

ensure() {
  if ! which "$1" >/dev/null; then
    echo -e "${BOLD}${MAGENTA}FATAL${RESET} ${BOLD}$1${RESET} not available"
    exit 1
  fi
}

log() {
  if which gum >/dev/null; then
    level="$1"
    shift
    gum log --structured -l "$level" "$@"
  else
    local level="$1"
    shift
    echo -ne "[${BOLD}${BLUE}$level]${RESET}" "$@"
  fi
}

raise() {
  log fatal "$@"
  exit 1
}
