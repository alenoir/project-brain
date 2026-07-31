# RFC 0002 — Agent-first trust model

- **Status**: Accepted (founding-maintainer direction, 2026-07-28)
- **Author(s)**: founding session, from direct field feedback on the first POC
- **Created**: 2026-07-28
- **Spec version targeted**: 0.1 (draft — amended in place, pre-1.0)

## Summary

Two changes that shift the daily burden from the human to the agent, without
touching the core guarantee (canonical truth stays human-signed):

1. **Two trust tiers.** Agents may create *and maintain directly* all
   knowledge at authority `informative` and below — notably `state/`,
   `knowledge/`, `architecture/`, `guides/`. The candidates inbox is no
   longer the only door: it becomes the staging area for *canonical-bound*
   proposals only (rules, invariants, decisions). The human's recurring job
   shrinks from "review everything the agent learns" to "sign the few
   things that bind".
2. **Merge-verification.** A reviewed pull request whose description lists
   the items it promotes counts as Verification by the merger: merging *is*
   signing. Tooling completes the `verified: {by: <merger>, at: <date>}`
   block mechanically after merge. The one-click promotion replaces the
   per-item ceremony.

Additionally, the Writer protocol gains *duties*, not just permissions: keep
`state/now.md` true after significant work; consult `rules/` and `decisions/`
before editing governed areas. The brain becomes primarily **a tool the
agent uses and feeds**, that the human governs by exception.

## Motivation

First field deployment (a real POC, July 2026): `brain-init` generated 22
items, all `candidate`/`draft`. Observed outcomes:

- **User overload.** The human faced a 22-item review queue as the price of
  *any* value — the exact ADR-theatre failure the standard was designed to
  avoid, reproduced at day one.
- **Agent under-use.** Since candidates bind no one and nothing obliged the
  agent to maintain anything, the brain was inert between sessions: state
  went stale, no updates flowed, the agent didn't consult it enough.
- The ETH evidence says *curated* context helps agents; a brain whose
  entire content sits in an unloadable purgatory delivers none of that
  value while still charging the human for curation.

The founding principle P4 ("truth is governed, not generated") was
over-applied: it gated **all** knowledge, when its purpose is to gate
**binding** knowledge. `informative` content already, by definition (spec
5.1), binds no one — requiring human ceremony to create something that
binds no one was pure friction.

## Design

### Trust tiers

| Tier | Authority | Who maintains | Where |
|---|---|---|---|
| **Working knowledge** | `candidate`, `informative` | agents directly (truthful provenance, `updated` maintained) | `state/`, `knowledge/`, `architecture/`, `guides/`, `candidates/` |
| **Binding knowledge** | `canonical` | humans only (explicit or merge-verification) | `rules/`, `decisions/`, and any item a human promotes |

- Agents still never write `authority: canonical` and never author a
  `verified` block on their own initiative (unchanged, P4).
- `rules/` and `decisions/` entries are canonical-bound by nature: agents
  propose them via `candidates/` (or a promotion PR), never place them
  directly.
- Canonical items remain untouchable in substance by agents (amendment
  proposals only, unchanged).

### Merge-verification

- A project MAY declare `verification: merge` in its Brain Manifest
  (RECOMMENDED for solo developers and small teams; `explicit` remains the
  conservative default in the spec).
- Under `merge` mode: a PR whose description lists promoted item ids, once
  merged by a human, constitutes Verification by that human. The
  `verified` block is then written mechanically (scribe rule generalized).
- The invariant checked by the validator is unchanged: **canonical ⇒
  verified block present**. Merge mode changes how the block gets there,
  not whether it must exist.

### Writer duties (was: permissions)

A conformant Writer, in a session that did significant work, now **SHOULD**:
- update `state/now.md` before ending (it is Tier-1: direct maintenance);
- record durable findings as `informative` knowledge or candidates;
- consult `rules/` + matching `on_demand` items before editing governed
  paths, and `decisions/` + `archive/` before asking the human "why" or
  guessing.

## Principles check

- **P4** — preserved where it matters: nothing *binding* exists without a
  named human act. Narrowed from "all knowledge" to "binding knowledge",
  which is what its rationale always argued.
- **P12** (the brain must not compete with building the project) — this RFC
  is P12's enforcement arm: the human's recurring cost drops to signing
  rules and decisions.
- **P9** (context budget) — improved: informative content is loadable
  context immediately, instead of waiting in purgatory.

## Impact

- **Existing brains**: none breaking. Items already in `candidates/` may be
  re-homed as `informative` by their maintainers where appropriate.
- **Tools**: Writers gain direct-maintenance rights on Tier-1 areas;
  Validators unchanged (the canonical⇒verified invariant is untouched);
  the reference skill/curator gain the new duties.
- **Spec text**: chapters 01 (Writer), 06 (trust tiers, merge-verification),
  08 (writing protocol) amended; manifest field `verification` added to 09.

## Alternatives considered

- **Keep candidate-only writing, improve triage UX** — rejected: the POC
  showed the queue itself is the problem, not its interface.
- **Let agents write canonical with post-hoc human audit** — rejected:
  breaks P4's core; an unaudited week is a week of fabricated truth.

## Open questions

1. Should `verification: merge` become the spec default at 1.0?
2. Does Tier-1 need a size/entropy guard (e.g. curator dedupe duty) to
   prevent informative sprawl? (Assigned to the curator's gardening pass
   for now.)
