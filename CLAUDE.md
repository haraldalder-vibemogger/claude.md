# CLAUDE.md

## Project
<!-- 3–5 lines: what this is, stack, entry points. No more. -->
- Stack: [fill in]
- Entry: [fill in]
- Test: `[exact command]`   Build: `[exact command]`   Lint: `[exact command]`

## Operating mode: LOOP, not chat
You operate inside a verification loop, not a conversation.
1. Every task MUST start with a binary-verifiable goal (yes/no checkable:
   "tests X, Y pass", "file exists with N sections", "lint clean"). If the
   user's request has no verifiable goal, derive one and state it first.
2. Plan before code. For non-trivial tasks: a written plan with a check per
   step — `1. [step] -> verify: [check]`. Wait for approval only if the plan
   is risky (see .claude/rules/bayes.md); otherwise execute.
3. NEVER verify your own implementation. Delegate verification to the
   verifier subagents (.claude/agents/verifier-*.md). Loop
   implementer -> verifiers -> fixer until BOTH verifiers pass. Max 5
   iterations, then escalate to a human with a summary of what's blocking.
4. Anything runnable as a shell command MUST run as a shell command
   (tests, lint, build, grep). Never simulate or predict tool output.
5. Every caught mistake becomes a durable correction: append it to
   docs/stream/LEARNINGS.md in the same turn you fix it.

## Behavioral rules
Follow .claude/rules/karpathy.md at all times. Summary:
- Don't assume. Don't hide confusion. Surface tradeoffs. Ask when uncertain.
- Minimum code that solves the problem. Nothing speculative.
- Touch only what you must. Every changed line traces to the request.
- Define success criteria; loop until verified.

## Decision protocol
Before choosing between implementation approaches, or before any change
touching auth, payments, data migrations, public APIs, or data deletion,
run the procedure in .claude/rules/bayes.md and pick the path with the best
expected value. Log the assessment to docs/stream/DECISIONS.md.

## Memory protocol (keep project memory fresh)
- START of session: read docs/stream/STATE.md and the latest file in
  docs/stream/CHANGES/. Do not re-derive project state from the repo.
- DURING work: after each completed step, append one line to the current
  docs/stream/CHANGES/YYYY-MM-DD-<topic>.md — what changed, which files, why.
- END of a unit of work: overwrite the "Current" section of STATE.md and
  append decisions to DECISIONS.md.
- STATE.md > your recollection. If they conflict, trust the file, then fix it.

## Model routing (token economy)
You may be running as any tier. Respect the role boundaries:
- ARCHITECT tier (strongest model): decomposition, specs, cross-cutting
  decisions, final review of merged work. Writes tasks, not code.
- CODER tier (mid model): implements ONE spec at a time, exactly as written.
  If the spec is ambiguous, return it to the architect — do not improvise.
- VERIFIER tier (cheap model): mechanical checks against spec + adversarial
  critique. Read-only tools. Never fixes, only reports.
Never burn architect-tier tokens on implementation or verifier work. Fan out
independent tasks to parallel subagents; keep each context minimal.

## Hard rules
- No secrets in code, logs, or memory files. Ever.
- No `git push --force`, no destructive migrations, no deleting data without
  explicit human confirmation.
- Project anti-patterns: see .claude/rules/forbidden.md.
- If two runs disagree or verification flip-flops, STOP and report — don't loop.
