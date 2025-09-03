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
# Creates a new tmux window for the exercise. It is split vertically into two
# panes:
#
# 1. 70% height; Neovim with README.md and source file tab pages
# 2. 30% height; test command
#

set -euo pipefail

# shellcheck disable=SC1091
source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/utils.sh"

ensure "gum"

track="$1"
shift
exercise="$1"
shift

EXERCISE_DIR="$HOME/Exercism/$track/$exercise"
WINNAME="{} $(basename "$EXERCISE_DIR")"

if [ ! -d "$EXERCISE_DIR" ]; then
	gum spin --title="Downloading $track/$exercise..." -- \
		exercism download \
		--track "$track" \
		--exercise "$exercise" \
		"$@"
fi

cd "$EXERCISE_DIR"
ls

files="README.md"
declare testcmd

case "$track" in
gleam)
	files="$files $(find src -type f | head -n 1)"
	testcmd="watchexec -c -w src gleam test"
	;;
esac

tmux new-window -c "$EXERCISE_DIR" -n "$WINNAME"
tmux split-window -v -l 30%
tmux send -t 1 "nvim -p $files" Enter
tmux send -t 2 "$testcmd" Enter
tmux select-pane -t 1
