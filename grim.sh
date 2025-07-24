#!/bin/bash
#
# Usage: grim.sh [flags] <script>
#
# Executes a grimoire script. If no <script> is provided, a script
# chooser will be shown.
#
# Arguments:
#   <script>    Name of the script (sans extension)
#
# Flags:
#   -h, --help    Show the help message
#

set -euo pipefail

GRIMOIRE="${XDG_DATA_HOME:-$HOME/.local/share}/grimoire"

if [ ! -d "$GRIMOIRE" ]; then
  echo "Grimoire not found"
  exit 1
fi

if ! which gum >/dev/null; then
  echo "Gum not found"
  exit 1
fi

docs() {
  cat <<EOF
Usage: grim.sh [flags] <script>

Executes a grimoire script. If no <script> is provided, a script
chooser will be shown.

Arguments:
  <script>    Name of the script (sans extension)

Flags:
  -h, --help    Show the help message
EOF
}

if ! which gum >/dev/null; then
  echo "Gum not found"
  exit 1
fi

raise() {
  gum log -l fatal "$1"
  exit 1
}

scriptname=""
scriptargs=""

# Parse options
while [ $# -gt 0 ]; do
  case "$1" in
  --)
    shift
    while [ $# -gt 0 ]; do
      scriptargs="$scriptargs \"$1\""
      shift
    done
    break
    ;;
  -h | --help)
    docs
    exit 0
    ;;
  -*)
    docs
    raise "Unknown flag: $1"
    ;;
  *)
    if [ -z "$scriptname" ]; then
      scriptname=$1
    else
      docs
      raise "Unknown flag: $1"
    fi
    shift
    ;;
  esac
done

if [ -z "$scriptname" ]; then
  scriptnames="$(for file in "$GRIMOIRE"/*.sh; do basename "$file" .sh; done)"
  # shellcheck disable=SC2086
  scriptname="$(gum filter $scriptnames)"
fi

# Run the script
eval "$GRIMOIRE/${scriptname}.sh $scriptargs"
