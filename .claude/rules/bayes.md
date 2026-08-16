# Decision engine — likelihood-ratio Bayes

An LLM is not a probability engine, and these numbers don't fall out of it
objectively — it assigns them. The value isn't "precise probabilities"; it's
forcing the model to list competing hypotheses, justify each update, and run
cheap disconfirming tests instead of a confident "looks correct." It's
reasoning discipline, not an oracle. Calibrate the numbers to your own repo.

Work in ODDS, not probabilities — odds multiply cleanly, so each piece of
evidence is a discrete, auditable step.

## The one formula
    odds = P / (1 - P)                              # P -> odds
    posterior_odds = prior_odds * LR1 * LR2 * ...   # update
    P = odds / (1 + odds)                           # odds -> P back

LR (likelihood ratio) is one evidence multiplier:
    LR = P(seeing this | hypothesis true) / P(seeing this | hypothesis false)
LR > 1 supports the hypothesis, LR < 1 weakens it, LR = 1 is useless.

Worked example (root-cause of a bug):
    start 0.50 (odds 1:1)
    -> a failing test reproduces it in this module (x8)  -> odds 8:1   (P=0.89)
    -> git blame: the line was changed yesterday   (x4)  -> odds 32:1  (P=0.97)
    -> but a green unit test already covers it    (x0.3) -> odds 9.6:1 (P=0.91)

## Two modes
A. Bug diagnosis — hypotheses are candidate root causes. Force yourself to
   list >=3 ("bug in my code" / "bug in the data" / "bug in a dependency" /
   "the test lies").
B. Approach selection — hypotheses are "approach X works without a rewrite."
   Compute a posterior for each, then choose by expected value (below).

## Priors (ground them; don't pull from thin air)
- Strongest prior: docs/stream/LEARNINGS.md. If this repo has dropped this
  class of bug before, start above 0.5.
- Base rates: "off-by-one in date/timezone math" >> "compiler bug";
  "race in async code" high, near-zero in a pure function.
- Never set a prior to 0 or 1 — there'd be nothing to update.

## Likelihood-ratio table (starter set — tune it to your repo)

Diagnosis — evidence FOR "this is the cause":
| Evidence | LR |
|---|---|
| A failing test reproduces the bug right here | x8 |
| Stack trace / log points at this module | x5 |
| git blame / git bisect flags the suspected commit | x4 |
| Same symptom is already in LEARNINGS with this cause | x4 |
| Changed only this -> symptom gone (and back on revert) | x15 |
| "Looks similar" reasoning, no run | x1.3 |

Diagnosis — evidence AGAINST (LR < 1):
| Evidence | LR |
|---|---|
| A green test already covers this hypothesis | x0.3 |
| Type checker / linter clean on this path | x0.5 |
| Reproduces even where the suspected code isn't present | x0.1 |
| The cheap experiment returned the opposite result | x0.1 |

Approach selection — evidence FOR "path X works":
| Evidence | LR |
|---|---|
| Already done this way in this repo; LEARNINGS confirms | x5 |
| A 20-line spike/prototype worked | x8 |
| Path is reversible (easy rollback, feature flag) | x2 |
| Official docs describe exactly this case | x3 |
| Path touches auth/payments/migrations/data | x0.4 |
| Requires a new dependency with unclear maintenance | x0.5 |

## Action thresholds (gate on a number, not a mood)
- P >= 0.90 -> act: fix on this cause / build this approach.
- 0.30 < P < 0.90 -> run one more cheap experiment. Do NOT code blind.
- P <= 0.30 -> drop the hypothesis/approach to save effort; move to the next.
- Special case: any path with impact >= 4 (data loss / irreversible change)
  needs P >= 0.97 OR reversibility, else escalate to a human.

## The cheap-experiment rule (this is what makes it work)
For the top-2 hypotheses by posterior, find the cheapest test that moves the
LR the most: one grep, one log line, one throwaway test. RUN it (a shell
command, not reasoning). Prioritize the test most likely to DISPROVE the
current leader, not confirm it.

## Self-correction protocol
Never lock in the first plausible cause as truth.
1. Have a leading hypothesis -> you MUST run a confirming test.
2. If the test doesn't confirm cleanly, return to the table and recompute.
3. If you already started fixing and disconfirming evidence appears
   (LR <= 0.2), ROLL BACK the change and strike the hypothesis. Write it
   explicitly: "P(H1) was 0.85; observed X; now 0.12 because ...".
4. Record the false hypothesis and what disproved it in LEARNINGS — this
   calibrates future priors and LRs.

## Chain evaluation (multi-step plans)
A plan of independent steps s1..sn succeeds as the product of step successes:
    P(plan) = product of P(si)
    EV(plan) = P(plan) * value - sum of ( P(problem_i) * impact_i * fix_cost_i )
The trap this catches: five "confident" 0.9 steps = 0.59 overall. Long
chains of confident steps are risky — split the plan into verifiable chunks
and close each with a loop before the next. Pick the max-EV plan; on a tie,
take the reversible one.

## Output format (log to docs/stream/DECISIONS.md)
| Hypothesis | Prior | Evidence (LR) | Posterior P | Cheap test | Verdict |
|---|---|---|---|---|---|
| H1 root=race | 0.30 | test x8, blame x4 | 0.91 | run 100x parallel | ACT |
| H2 root=cache | 0.30 | green test x0.3 | 0.11 | — | DROPPED |

## Calibration (so this doesn't become theater with numbers)
Every N decisions, check predictions against reality: of the cases where you
said P~0.9, ~9 of 10 should have come true. If it's 5 of 10, your LRs are
inflated — cut them. DECISIONS/LEARNINGS give you this check for free.
Without calibration, the Bayesian layer is just decoration.
