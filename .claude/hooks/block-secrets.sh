#!/usr/bin/env bash
# Example PreToolUse hook: block writes that look like they contain secrets.
# Wire up in .claude/settings.json under hooks.PreToolUse for Write/Edit.
# Reads the tool-call JSON on stdin; exits 2 to BLOCK.

set -euo pipefail
payload="$(cat)"

# Extract the content being written (adjust jq path to your tool schema).
content="$(printf '%s' "$payload" | jq -r '.tool_input.content // .tool_input.new_str // empty')"

# Crude secret patterns — replace with your real detectors / a proper scanner.
if printf '%s' "$content" | grep -qiE '(api[_-]?key|secret|password|private[_-]?key)[[:space:]]*[:=]'; then
  echo "Blocked: potential secret in write. Move it to an env var / secret store." >&2
  exit 2
fi

exit 0
