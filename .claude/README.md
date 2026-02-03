# Global Claude Config

This directory contains machine-wide Claude Code settings. It's managed by dotfiles and symlinked to `~/.claude/` via `bootstrap.sh`.

## Contents

| File | Purpose |
|------|---------|
| `settings.json` | Global settings: model preference, hooks, statusline config |
| `CLAUDE.md` | Global instructions applied to all Claude sessions |
| `rules/` | Symlink to `~/.dotfiles/docs/rules/` — coding standards and preferences |
| `statusline.py` | Custom statusline script (displays session metadata) |
| `bootstrap.sh` | Creates symlinks from this directory to `~/.claude/` |

## Why here (not in-project)?

These settings are:
1. **Machine-specific, not project-specific** — model preference, statusline, hooks
2. **Already git-tracked** in dotfiles
3. **Portable** across machines via dotfiles bootstrap

Project-specific Claude config (skills, agents, output styles) belongs in the project's own `.claude/` directory. See [`~/tools/.claude/README.md`](https://github.com/calebgregory/tools/tree/main/.claude) for the full taxonomy.

## Setup

Run [`bootstrap.sh`](bootstrap.sh) after cloning dotfiles on a new machine.
