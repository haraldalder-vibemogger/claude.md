# Hooks — deterministic checks, not prompts

Any "must always happen" rule belongs here as a hook, not as a text
instruction in CLAUDE.md. Text rules are followed probabilistically; hooks
always fire. A hook that exits with code 2 BLOCKS the action.

Configure hooks in .claude/settings.json (PreToolUse / PostToolUse / etc.).
Hook input is JSON on stdin. Use exit code 2 to block; the deprecated
decision/reason return format should not be used.

Below is a sample block-on-secret hook. This is an example — adapt paths and
patterns to your repo, and wire it up in .claude/settings.json.
