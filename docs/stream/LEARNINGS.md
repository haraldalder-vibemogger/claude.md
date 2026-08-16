# LEARNINGS — caught mistakes become permanent rules

A verification loop only helps if every caught mistake becomes a DURABLE
correction — otherwise the loop catches the same thing forever. Each entry
should state the mistake, the resulting rule, and any prior it updates.
When this file grows large, distill the top rules into the CLAUDE.md core
or .claude/rules/forbidden.md and archive the rest.

## Example
- L-31 [2026-08-15] Token refresh had a race under parallel requests.
  Rule: any shared-state async in this repo needs a single-flight guard.
  Prior updated: P(concurrency bug | "flaky auth test") 0.2 -> 0.6
