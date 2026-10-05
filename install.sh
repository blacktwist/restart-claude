#!/usr/bin/env bash
# Installs the /restart skill and the shell wrapper (zsh or bash) that relaunches claude.
# Usage: ./install.sh [zsh|bash]   (defaults to your login shell, from $SHELL)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.claude/skills
ln -sfn "$here/restart" ~/.claude/skills/restart
echo "✓ Linked skill: ~/.claude/skills/restart -> $here/restart"

shell_name="${1:-$(basename "${SHELL:-}")}"
case "$shell_name" in
  zsh)  rc=~/.zshrc ;;
  bash)
    # macOS terminals start login shells, which read ~/.bash_profile.
    if [[ "$(uname)" == "Darwin" ]]; then rc=~/.bash_profile; else rc=~/.bashrc; fi ;;
  *)
    echo "✗ Unsupported shell '$shell_name'. Add this to your shell's rc file manually:"
    echo "  source \"$here/restart-wrapper.sh\""
    exit 1 ;;
esac

line="source \"$here/restart-wrapper.sh\""
old_line="source \"$here/restart.zsh\""
touch "$rc"
if grep -qF "$old_line" "$rc"; then
  # Upgrade from the old zsh-only file name.
  tmp=$(mktemp)
  while IFS= read -r l || [[ -n "$l" ]]; do
    if [[ "$l" == "$old_line" ]]; then printf '%s\n' "$line"; else printf '%s\n' "$l"; fi
  done < "$rc" > "$tmp"
  cat "$tmp" > "$rc" && rm -f "$tmp"
  echo "✓ Updated $rc: $line"
elif grep -qF "$line" "$rc"; then
  echo "✓ $rc already sources restart-wrapper.sh"
else
  printf '\n# Claude Code /restart support\n%s\n' "$line" >> "$rc"
  echo "✓ Added to $rc: $line"
fi
echo "Open a new terminal (or: source $rc), start claude, then use /restart."
