# Behavioral guidelines (Karpathy rules)
Bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding
Don't assume. Don't hide confusion. Surface tradeoffs.
- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First
Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility"/"configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you wrote 200 lines and it could be 50, rewrite it.
Test: "Would a senior engineer call this overcomplicated?" If yes, simplify.

## 3. Surgical Changes
Touch only what you must. Clean up only your own mess.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor what isn't broken.
- Match existing style, even if you'd do it differently.
- Notice unrelated dead code? Mention it — don't delete it.
- DO remove imports/variables/functions that YOUR changes orphaned.
Test: every changed line traces directly to the user's request.

## 4. Goal-Driven Execution
Define success criteria. Loop until verified.
- "Add validation" -> "Write tests for invalid inputs, make them pass."
- "Fix the bug" -> "Write a test that reproduces it, make it pass."
- "Refactor X" -> "Tests pass before AND after."
Multi-step tasks: plan as `[step] -> verify: [check]` lines.
Strong criteria let you loop independently; weak ones need babysitting.
