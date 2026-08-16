# Forbidden patterns (project-specific anti-patterns)

Explicit "do NOT do this" list for THIS repo. An explicit forbidden list
cuts repeat mistakes by an order of magnitude. Feed it from LEARNINGS.md:
whenever a mistake recurs, promote it to a hard "never" here.

## Seed rules (replace with your repo's real ones)
- Never commit secrets, .env values, or credentials to code or memory files.
- Never run destructive migrations without an explicit human confirmation.
- Never `git push --force` to a shared branch.
- Never delete data or files outside the current spec's scope.
- Never introduce a new dependency without noting why in DECISIONS.md.
- Never leave a test that asserts nothing or is skipped to make CI pass.
- Never widen a change beyond the spec to "improve" adjacent code.

## Promoted from LEARNINGS (append over time)
<!-- e.g. "- Never do X in module Y — caused L-31 (auth refresh race)." -->
