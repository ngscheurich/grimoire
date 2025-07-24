#!/bin/bash
#
# Usage: tp.sh
#
# Presents a choice of tmuxp workspaces and loads the selected one.
#

set -euo pipefail

# shellcheck disable=SC1091
source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/utils.sh"

ensure "fd"
ensure "gum"

TMUXPDIR="${HOME}/.config/tmuxp"

if [ ! -d "$TMUXPDIR" ]; then
  log fatal "tmuxp directory does not exist" directory "$TMUXPDIR"
  exit 1
fi

WORKSPACE=$(fd . --type f "$TMUXPDIR" | sed "s|^${TMUXPDIR}/\(.*\).yaml|\1|" | gum filter)

tmuxp load "${TMUXPDIR}/${WORKSPACE}.yaml"
