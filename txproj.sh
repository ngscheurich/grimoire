#!/bin/bash
#
# Usage: theme.sh [options]
#
# Starts and/or attaches to a tmux session named after the current directory.
#

set -euo pipefail

SESSION="${PWD##*/}"
LOCAL_CONF=./.tmux.local.conf

session_exists() {
  tmux list-sessions 2>/dev/null | grep "^$SESSION: "
}

if session_exists; then
  tmux attach -t "$SESSION"
elif [ -e $LOCAL_CONF ]; then
  tmux new-session -Ads "$SESSION"
  tmux source-file $LOCAL_CONF
  tmux attach -t "$SESSION"
else
  tmux new-session -As "$SESSION"
fi
