#!/usr/bin/env bash
# Installs the /restart skill and the shell wrapper (zsh or bash) that relaunches claude.
# Usage: ./install.sh [zsh|bash]   (defaults to your login shell, from $SHELL)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.claude/skills
ln -sfn "$here/restart" ~/.claude/skills/restart
echo "✓ Linked skill: ~/.claude/skills/restart -> $here/restart"

bash "$here/restart/scripts/setup-wrapper.sh" "$@"
