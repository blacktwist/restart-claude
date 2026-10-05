# Wrapper that lets the /restart skill relaunch Claude Code in the same terminal.
# Source this from ~/.zshrc (install.sh does it for you).

claude() {
  local marker args=("$@") id rc a drop_val prev_flag
  local -a kept
  marker=$(mktemp -t claude-restart) || { command claude "$@"; return; }

  while true; do
    : > "$marker"
    CLAUDE_RESTART_MARKER="$marker" command claude "${args[@]}"
    rc=$?

    id=$(<"$marker" 2>/dev/null)
    if [[ -z "$id" ]]; then
      rm -f "$marker"
      return $rc
    fi

    stty sane 2>/dev/null
    # Keep launch flags (e.g. --model opus, --dangerously-skip-permissions) but
    # drop any previous resume/continue selection and the initial prompt.
    kept=() drop_val=0 prev_flag=0
    for a in "${args[@]}"; do
      if [[ "$a" != -* ]]; then
        if (( drop_val )); then :
        elif (( prev_flag )); then kept+=("$a")   # value of a kept flag
        fi
        drop_val=0 prev_flag=0
        continue
      fi
      drop_val=0 prev_flag=0
      case "$a" in
        -c|--continue|--resume=*|--session-id=*|--fork-session) ;;
        -r|--resume|--session-id) drop_val=1 ;;
        *=*) kept+=("$a") ;;
        *) kept+=("$a"); prev_flag=1 ;;
      esac
    done
    args=("${kept[@]}" --resume "$id")
  done
}
