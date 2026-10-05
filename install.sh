#!/usr/bin/env bash
# Installs the /restart skill and the zsh wrapper that relaunches claude.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.claude/skills
ln -sfn "$here/restart" ~/.claude/skills/restart
echo "✓ Linked skill: ~/.claude/skills/restart -> $here/restart"

line="source \"$here/restart.zsh\""
if grep -qF "$line" ~/.zshrc 2>/dev/null; then
  echo "✓ ~/.zshrc already sources restart.zsh"
else
  printf '\n# Claude Code /restart support\n%s\n' "$line" >> ~/.zshrc
  echo "✓ Added to ~/.zshrc: $line"
fi
echo "Open a new terminal (or: source ~/.zshrc), start claude, then use /restart."
