#!/bin/bash
#
# Usage: git_fuckup.sh
#
# Creates a uniquely-named copy of the current Git branch as fuck-up
# insurance.
#

set -euo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD)
TIME=$(date +%s%3N)

git switch --create "fuckup-insurance-$TIME--$BRANCH"
git switch -
