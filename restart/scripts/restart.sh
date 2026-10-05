#!/usr/bin/env bash
# Close the running Claude Code session and have it resumed.
#   - If claude was launched through the restart.zsh wrapper, the wrapper
#     relaunches `claude --resume <id>` automatically.
#   - Otherwise the resume command is copied to the clipboard.
# Usage: restart.sh [--dry-run]
set -euo pipefail

dry_run=0
[[ "${1:-}" == "--dry-run" ]] && dry_run=1

session_id="${CLAUDE_CODE_SESSION_ID:-}"
claude_pid="${CLAUDE_PID:-}"

if [[ -z "${session_id}" || -z "${claude_pid}" ]]; then
  echo "restart: CLAUDE_CODE_SESSION_ID / CLAUDE_PID not set — not running inside Claude Code?" >&2
  exit 1
fi

resume_cmd="claude --resume ${session_id}"

# Tell the user directly on the terminal: tool output may never be shown
# because the session dies right after this script returns.
say() { { printf '\n%s\n' "$*" > /dev/tty; } 2>/dev/null || printf '%s\n' "$*"; }

if [[ -n "${CLAUDE_RESTART_MARKER:-}" ]]; then
  mode="wrapper"
else
  mode="clipboard"
fi

if (( dry_run )); then
  echo "session: ${session_id}"
  echo "pid:     ${claude_pid}"
  echo "mode:    ${mode}${CLAUDE_RESTART_MARKER:+ (marker: ${CLAUDE_RESTART_MARKER})}"
  echo "would run: kill -TERM ${claude_pid}, then: ${resume_cmd}"
  exit 0
fi

if [[ "${mode}" == "wrapper" ]]; then
  printf '%s\n' "${session_id}" > "${CLAUDE_RESTART_MARKER}"
  say "↻ Restarting Claude Code session ${session_id}…"
  echo "Restarting session ${session_id}…"
else
  printf '%s' "${resume_cmd}" | pbcopy 2>/dev/null || true
  say "↻ Closing Claude Code. Resume command copied to clipboard: ${resume_cmd}"
  echo "Closing. Resume with: ${resume_cmd} (copied to clipboard)"
  echo "Tip: for automatic relaunch, run in your shell: bash $(cd "$(dirname "$0")" && pwd)/setup-wrapper.sh"
fi

# Detach so this tool call returns before claude goes down.
# Escalate to SIGKILL if claude ignores SIGTERM (the transcript is append-only).
nohup bash -c "sleep 2; kill -TERM ${claude_pid} 2>/dev/null; sleep 3; kill -0 ${claude_pid} 2>/dev/null && kill -KILL ${claude_pid}" >/dev/null 2>&1 &
