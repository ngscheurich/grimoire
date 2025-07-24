#!/bin/bash
#
# Usage: theme.sh [options]
#
# Changes the system theme. Requires that the `themes` directory is present.
# With no options, prompts the user for a theme to apply.
#
# Options:
#   -t, --theme    Theme to apply
#

set -euo pipefail

# shellcheck disable=SC1091
source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/utils.sh"

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
GRIMOIRE="$DATA_HOME/grimoire"
THEMES="$DATA_HOME/themes"
THEME_LINK="$HOME/.theme"

ensure "gum"
ensure "osascript"

if [ ! -d "$GRIMOIRE" ]; then
  echo "Grimoire not found"
  exit 1
fi

if [ ! -d "$THEMES" ]; then
  gum log -l fatal "themes directory not found"
  exit
fi

THEME="$(gum choose "$(basename -a "$THEMES"/*)")"

# Create symlink to chosen theme
if [ -d "$THEME_LINK" ]; then rm "$THEME_LINK"; fi
eval "ln -s ${THEMES}/$THEME $THEME_LINK"

# Reload Ghotty config
osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}'

# Set Tmux theme
"${THEME_LINK}/tmux.sh"

# Load theme in all Neovim instances
"$GRIMOIRE/nvim_send.sh" "<Cmd>lua require('ngs.util').reload_theme(true)<CR>"
