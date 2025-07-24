#!/bin/bash
#
# Usage: init.sh
#
# Clones the Grimoire repo and creates a `grim` command.
#

set -euo pipefail

REPO="git@github.com:ngscheurich/grimoire.git"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/grimoire"
LINK="$HOME/.local/bin/grim"

# Clone repo
if [ -d "$DEST" ]; then
  echo "👻 Nothing happens..."
else
  git clone "$REPO" "$DEST"
fi

# Create symlink
if [ -f "$LINK" ]; then rm "$LINK"; fi
eval "ln -s $DEST/grim.sh $LINK"
