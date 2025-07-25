#!/bin/bash
#
# Usage: exercise.sh <track> <exercise> [flags]
#
# Arguments:
#	<track>       Language track
#	<exercise>    Exercise name
#
# Flags:
#	Additional flage to pass to the exercism CLI.
#
#  Opens the specified Exercism exercise in Neovim. Downloads it first
#  if necessary.
#

set -euo pipefail

# shellcheck disable=SC1091
source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/utils.sh"

ensure "gum"

TRACK="$1"
shift
EXERCISE="$1"
shift

EXERCISE_DIR="$HOME/Exercism/$TRACK/$EXERCISE"

if [ ! -d "$EXERCISE_DIR" ]; then
	gum spin --title="Downloading $TRACK/$EXERCISE..." -- \
		exercism download \
		--track "$TRACK" \
		--exercise "$EXERCISE" \
		"$@"
fi

cd "$EXERCISE_DIR"
ls

FILES="README.md"

case "$TRACK" in
gleam)
	FILES="$FILES $(find src -type f | head -n 1)"
	;;
esac

eval "nvim -p $FILES"
