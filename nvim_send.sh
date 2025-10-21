#!/bin/bash
#
# Usage: nvim_send.sh <command>
#
# Sends a command to all current Neovim instances.
#
# Arguments:
#   <command>    Neovim command to run
#

set -euo pipefail

if [ $# -eq 1 ]; then
	find "${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}"/*/nvim.*.0 2>/dev/null | while read -r server; do
		nvim --server "$server" --remote-send "$1" >/dev/null 2>&1
	done
else
	exit 1
fi
