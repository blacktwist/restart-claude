#!/usr/bin/env bash
# Adds the /restart shell wrapper (zsh or bash) to your shell's startup file,
# so Claude Code relaunches itself after /restart.
# Usage: setup-wrapper.sh [zsh|bash]   (defaults to your login shell, from $SHELL)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

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
touch "$rc"
if grep -qxF "$line" "$rc"; then
  echo "✓ $rc already loads the /restart wrapper"
elif grep -q '^source ".*/\(restart\.zsh\|restart-wrapper\.sh\)"$' "$rc"; then
  # Upgrade a line from an older layout (restart.zsh or a different wrapper path).
  tmp=$(mktemp)
  while IFS= read -r l || [[ -n "$l" ]]; do
    case "$l" in
      'source "'*'/restart.zsh"'|'source "'*'/restart-wrapper.sh"') printf '%s\n' "$line" ;;
      *) printf '%s\n' "$l" ;;
    esac
  done < "$rc" > "$tmp"
  cat "$tmp" > "$rc" && rm -f "$tmp"
  echo "✓ Updated $rc: $line"
else
  printf '\n# Claude Code /restart support\n%s\n' "$line" >> "$rc"
  echo "✓ Added to $rc: $line"
fi
echo "Open a new terminal (or: source $rc), start claude, then use /restart."
