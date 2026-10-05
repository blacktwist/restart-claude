---
name: restart
description: Restart the current Claude Code session in place (close it and resume the same conversation), e.g. to pick up a freshly installed update.
disable-model-invocation: true
allowed-tools: Bash(bash ${CLAUDE_SKILL_DIR}/scripts/restart.sh*), Bash(bash ~/.claude/skills/restart/scripts/restart.sh*)
---

Run exactly this command and nothing else:

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/restart.sh
```

Then reply with only the script's output line, verbatim. Do not do anything else afterwards — this session is about to exit.
