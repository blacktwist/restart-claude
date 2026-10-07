# /restart for Claude Code

[![skills.sh](https://skills.sh/b/blacktwist/restart-claude)](https://skills.sh/blacktwist/restart-claude)

One command to restart your Claude Code session and land back in the same conversation.

![Demo: /restart closes Claude Code and resumes the same conversation, which still remembers what was said before](assets/demo.gif)

## Why

Every so often your Claude Code terminal shows:

> Update installed · Restart to update

To pick up the update you have to:

1. Quit the session.
2. Find the `claude --resume <session-id>` command it prints and copy it.
3. Paste it and run it to start the session again.

`/restart` does all three for you. Type it, and Claude Code closes and reopens on the same conversation, in the same terminal.

## How it works

- **`/restart` skill** runs a small script that saves the current session ID and tells Claude Code to quit. If Claude Code ignores the request, the script force-quits it a few seconds later.
- **Shell wrapper** (`restart/scripts/restart-wrapper.sh`, for zsh and bash) defines a `claude` shell function. When Claude Code exits because of `/restart`, the function relaunches it with `claude --resume <session-id>`. Launch flags such as `--model` or `--dangerously-skip-permissions` are kept. Any earlier `--resume`/`--continue` and the original prompt are dropped.
- **Fallback:** where the wrapper isn't loaded (for example, an app that starts Claude Code itself), `/restart` still closes the session and copies `claude --resume <session-id>` to your clipboard, so you only need to paste it.

## Install

Requires macOS and zsh or bash. There are two parts:

- **The skill** adds the `/restart` command to Claude Code.
- **The shell wrapper** relaunches Claude Code after it closes.

Install both for the full experience. With only the skill, `/restart` closes the session and copies the resume command to your clipboard.

### Quick install (recommended)

Install the skill with the [skills CLI](https://skills.sh):

```bash
npx skills add blacktwist/restart-claude -g -a claude-code -y
```

Then set up the shell wrapper:

```bash
bash ~/.claude/skills/restart/scripts/setup-wrapper.sh
```

Keep `-g`: it installs the skill for your user, so it works in every project. Without it the skill is installed into the current project only.

`setup-wrapper.sh` adds a line that loads the wrapper to your shell's startup file: `~/.zshrc` for zsh, or `~/.bash_profile` for bash on macOS. It detects your shell from `$SHELL`. To choose one yourself, pass `zsh` or `bash`. Running it again is safe and won't add a duplicate line.

Then open a new terminal (or `source` that file) and start `claude`.

If you skip the second step, `/restart` reminds you of it each time it falls back to the clipboard.

To update later, run `npx skills update`.

### Install from a clone

```bash
git clone git@github.com:blacktwist/restart-claude.git
cd restart-claude
./install.sh
```

`install.sh` links the skill into `~/.claude/skills/restart`, so a `git pull` updates it. Then it runs `setup-wrapper.sh` for you. It also accepts `zsh` or `bash` as an argument.

### Install manually

Claude Code loads personal skills from `~/.claude/skills/<skill-name>/`. Each skill is a folder with a `SKILL.md` file. To install this one, copy or link the repo's `restart` folder there:

```bash
cp -R restart-claude/restart ~/.claude/skills/restart
```

To use the skill in a single project only, put the folder in that project's `.claude/skills/restart` instead.

Then add this line to your shell's startup file (`~/.zshrc` for zsh, `~/.bash_profile` for bash on macOS):

```bash
source ~/.claude/skills/restart/scripts/restart-wrapper.sh
```

### Check that it works

1. Open a new terminal and run `type claude`. It should say `claude` is a shell function (in bash, it prints the function's code instead).
2. Start `claude`, type `/`, and look for `restart` in the command list. If it isn't there, start a fresh Claude Code session.

## Usage

When you see "Update installed · Restart to update", type:

```
/restart
```

Only you can trigger the skill. Claude won't run it on its own.

## Uninstall

```bash
npx skills remove restart -g   # or: rm -rf ~/.claude/skills/restart
```

Then remove the `# Claude Code /restart support` lines from your `~/.zshrc` or `~/.bash_profile`.

## License

[MIT](LICENSE)

---

Brought to you by [BlackTwist](https://blacktwist.app) — Monetize your Threads and Bluesky audience.
