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
OUTDIR="$HOME/.theme"

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

templates_dir="${THEMES}/$theme/templates"

# Render theme templates
gomplate --context palette="${THEMES}/${theme}/palette.toml" \
	--file "${templates_dir}/ghostty.tmpl" \
	--out "${OUTDIR}/ghostty" \
	--file "${templates_dir}/shell.fish.tmpl" \
	--out "${OUTDIR}/shell.fish" \
	--file "${templates_dir}/nvim.lua.tmpl" \
	--out "${OUTDIR}/nvim/lua/ngs/theme.lua" \
	--file "${templates_dir}/tmux.sh.tmpl" \
	--out "${OUTDIR}/tmux.sh"

# Reload Ghostty config
osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}'

# Load Tmux theme
tmux has-session >/dev/null 2>&1 && "${OUTDIR}/tmux.sh"

# Load theme in all Neovim instances
"${GRIMOIRE}/nvim_send.sh" "<Cmd>lua require('ngs.util').reload_theme(true)<CR>"
