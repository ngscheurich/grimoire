#!/bin/bash
#
# Usage: cmdnotif.sh [flags] <command>
#
# Arguments:
#	<command>    Command to run
#
# Executes a command, then displays a macOS system notification indicating
# success or failure.
#

set -euo pipefail

# shellcheck disable=SC1091
source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/utils.sh"

usage() {
	cat <<-"EOF"
		Usage: cmdnotif.sh [flags] <command>

		Arguments:
		  <command>    Command to run

		Executes a command, then displays a macOS system notification indicating
		success or failure.
	EOF
}

CMD="$*"

if eval "$CMD"; then
	title="🟢 Command finished"
else
	title="🔴 Command failed"
fi

osascript -e "display notification \"$CMD\" with title \"$title\""
