# /restart for Claude Code

One command to restart your Claude Code session and land back in the same conversation.

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
- **zsh wrapper** (`restart.zsh`) defines a `claude` shell function. When Claude Code exits because of `/restart`, the function relaunches it with `claude --resume <session-id>`. Launch flags such as `--model` or `--dangerously-skip-permissions` are kept. Any earlier `--resume`/`--continue` and the original prompt are dropped.
- **Fallback:** where the wrapper isn't loaded (for example, an app that starts Claude Code itself), `/restart` still closes the session and copies `claude --resume <session-id>` to your clipboard, so you only need to paste it.

## Install

Requires macOS and zsh. There are two parts:

- **The skill** adds the `/restart` command to Claude Code.
- **The zsh wrapper** relaunches Claude Code after it closes.

Install both for the full experience. With only the skill, `/restart` closes the session and copies the resume command to your clipboard.

### Quick install (recommended)

```bash
git clone git@github.com:blacktwist/restart-claude.git
cd restart-claude
./install.sh
```

`install.sh` does two things:

1. Links the skill into `~/.claude/skills/restart`.
2. Adds a line to your `~/.zshrc` that loads `restart.zsh`.

Then open a new terminal (or run `source ~/.zshrc`) and start `claude`.

### Install the skill in Claude Code manually

Claude Code loads personal skills from `~/.claude/skills/<skill-name>/`. Each skill is a folder with a `SKILL.md` file. To install this one, put the `restart` folder there.

To keep it updated with `git pull`, link it:

```bash
git clone git@github.com:blacktwist/restart-claude.git ~/restart-claude
mkdir -p ~/.claude/skills
ln -s ~/restart-claude/restart ~/.claude/skills/restart
```

Or copy it:

```bash
cp -R restart-claude/restart ~/.claude/skills/restart
```

To use the skill in a single project only, put the folder in that project's `.claude/skills/restart` instead.

Next, load the wrapper by adding this line to your `~/.zshrc`. Adjust the path to wherever you cloned the repo:

```bash
source ~/restart-claude/restart.zsh
```

### Check that it works

1. Open a new terminal and run `type claude`. It should say `claude` is a shell function from `restart.zsh`.
2. Start `claude`, type `/`, and look for `restart` in the command list. If it isn't there, start a fresh Claude Code session.

## Usage

When you see "Update installed · Restart to update", type:

```
/restart
```

Only you can trigger the skill. Claude won't run it on its own.

## Uninstall

```bash
rm ~/.claude/skills/restart
```

Then remove the `# Claude Code /restart support` lines from your `~/.zshrc`.

---

Brought to you by [BlackTwist](https://blacktwist.app) — Monetize your Threads and Bluesky audience.
