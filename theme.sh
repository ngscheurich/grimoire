#!/bin/bash
#
# Usage: theme.sh [flags] <theme>
# Changes the system theme. Requires that the `themes` directory is
# present. With no <theme>, prompts the user for a theme to apply.
#
# Arguments:
#     <theme>    Name of the theme
#
# Flags:
#     -h, --help    Show the help message
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

if [ ! -d "$GRIMOIRE" ]; then raise "Grimoire not found"; fi
if [ ! -d "$THEMES" ]; then raise "themes directory not found"; fi

usage() {
	cat <<-"EOF"
		Usage: theme.sh [flags] <theme>

		Changes the system theme. Requires that the `themes` directory is
		present. With no <theme>, prompts the user for a theme to apply.

		Arguments:
		    <theme>    Name of the theme

		Flags:
		    -h, --help    Show the help message
	EOF
}

declare theme

# Parse options
while [ $# -gt 0 ]; do
	case "$1" in
	-h | --help)
		usage
		exit 0
		;;
	-*)
		usage
		echo ""
		raise_flag "$1"
		;;
	*)
		if [ -z "$theme" ]; then
			theme="$1"
		else
			usage
			echo ""
			raise_flag "$1"
		fi
		shift
		;;
	esac
done

if [ -z "$theme" ]; then
	theme="$(fd . "$XDG_DATA_HOME/themes" -t d -d 1 | xargs basename -a | gum choose)"
fi

# Create symlink to chosen theme
if [ -d "$THEME_LINK" ]; then rm "$THEME_LINK"; fi
eval "ln -s ${THEMES}/$theme $THEME_LINK"

# Reload Ghotty config
osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}'

# Set Tmux theme
"${THEME_LINK}/tmux.sh"

# Load theme in all Neovim instances
"$GRIMOIRE/nvim_send.sh" "<Cmd>lua require('ngs.util').reload_theme(true)<CR>"
