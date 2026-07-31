---
name: project-brain
description: Read and respect this project's .brain/ directory (Project Brain standard). Use at the start of any coding, review, or analysis task in a repository containing .brain/brain.yaml, before finishing a significant session to record findings as candidates, and whenever the user mentions the "brain" in any language (init, update, status, backfill, promote, or any other brain request).
---

# Project Brain protocol

This repository carries a brain: governed project knowledge under `.brain/`
(Project Brain standard — https://github.com/alenoir/project-brain). Follow
this protocol instead of ad-hoc exploration.

## Brain command vocabulary

In this repository, **"the brain" always means the local `.brain/` directory
and its installed tooling** — never the standard's own repository (do not
clone it, do not browse it). When the human's request mentions the brain, in
any language, map it to one of these actions:

| The human says (any phrasing) | You do |
|---|---|
| "init the brain" | Run the `brain-init` skill (`.claude/skills/brain-init/SKILL.md`): analyze the repo, generate candidate content. |
| "update the brain" / "update the brain tools" | Run the update command (see **Maintenance** below). Nothing else. |
| "backfill the brain" / "mine the history" | Deep-backfill mode of `brain-init`: era-based history mining. |
| "brain status" / "where is the brain at" | Report: pending items in `candidates/`, items past `review_by`, canonical items missing `verified`, items flagged `needs-review`. |
| "validate the brain" / "lint the brain" | Run `curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/conformance/validate.py \| python3 - .brain` (needs `pyyaml`). Report violations; fix only what the human approves. |
| "promote `<item>`" | The human is verifying: on their explicit instruction, move the candidate to its area, set the authority they chose, and write `verified: {by: <their handle>, at: today}` — scribe for a named human decision; never promote on your own initiative. If the manifest declares `verification: merge`, prefer packaging promotions as a PR listing the promoted ids: merging is signing (spec 6.4). |
| "review the brain" / "garden the brain" / "triage" / "reorganize" / "archive" | Delegate to the **brain-curator** agent (`.claude/agents/brain-curator.md`) — the dedicated maintainer of the brain's health. Prefer it for any multi-item maintenance work. |
| anything else about "the brain" | Interpret it against the local `.brain/` content first; ask only if genuinely ambiguous. |

## Reading protocol (start of task)

1. **Handshake.** Read `.brain/brain.yaml`. Note `spec`, `conformance`, `entry`.
2. **Orient.** Read the `entry` file (normally `.brain/overview.md`).
3. **Select context.** If `.brain/context/manifest.yaml` exists:
   - pick the pack whose `intent` matches your task (`onboard`, `feature`,
     `bugfix`, `refactor`, `release`…), else the `default` pack;
   - load every item in `required`, in order;
   - load `recommended` items as budget allows, in order;
   - remember the `on_demand` rules: when your task touches matching paths,
     load the listed items before editing.
   If there is no context manifest, read `overview.md`, `state/now.md` (if
   present), and everything in `rules/`.
4. **Freshness.** An item past its `review_by` date is stale: treat it as
   needs-review, not as reliable truth. An item past `expires` binds no one.

## Authority rules (during the task)

- `authority: canonical` items are ground truth. **Never knowingly violate a
  canonical `invariant` or `rule`** — if the task seems to require it, stop
  and tell the human why.
- `informative` = useful context. `candidate` = unverified proposal — never
  treat as truth. `deprecated`/`archived` = history — follow `superseded_by`.
- Conflicts resolve by: authority level, then type (invariant > rule >
  decision > architecture > state > guide > knowledge > overview > note),
  then most recent `updated`. Surface any conflict between canonical items.
- If the code contradicts a canonical item, do not silently pick a side:
  flag the drift to the human (and propose a candidate, below).

## Consultation duties (during the task — not just at start)

- **Before editing files in a governed path** (any path matched by a rule's
  `scope` or a pack's `on_demand`): re-read the matching items first.
- **Before asking the human "why is this like this?" — or worse, guessing**:
  check `decisions/` and `archive/`. The answer is often already recorded.
- **Before creating anything** (a file, a pattern, a dependency): check
  `knowledge/` and `architecture/` for the existing shape.
- When the brain answered your question, say so; when it should have but
  didn't, that gap is a finding to record (below).

## Maintenance duties (the brain is yours to keep true — RFC 0002)

The brain has two tiers. **Tier 1 you maintain directly**, as part of
ordinary work — no permission needed, no candidates detour:

- `state/now.md` — **update it before ending any session of significant
  work** (in-flight, freezes, debt discovered). Keep `updated` current.
  This is a duty: a stale state file is your failure, not the human's.
- `knowledge/`, `architecture/`, `guides/` — create and update items
  freely at `authority: informative`, `provenance: agent` (or `mixed`),
  always with `sources`. Update existing items rather than duplicating.

**Tier 2 binds — you propose, humans sign**: `rules/`, `decisions/`, and
anything `canonical`. Proposals go to `.brain/candidates/<date>-<slug>.md`
(`authority: candidate`, `sources` required). Never set `canonical`, never
write a `verified` block on your own initiative, never change the substance
of a canonical item (amendment candidates only).

If the session produced significant decisions, architectural changes, or
drift discoveries, **delegate a curation pass to the brain-curator agent**
(`.claude/agents/brain-curator.md`) before ending — don't wait to be asked.

## Maintenance ("update the brain" / "update the brain tools")

When asked to update or refresh the Project Brain setup of this repository,
run, from the repo root:

    curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh -s -- --update

That is the entire update channel: it refreshes the installed skills/rules
and never touches `.brain/` content or `AGENTS.md`. Do **not** clone the
standard's repository (https://github.com/alenoir/project-brain) — nothing
in this repo depends on a local copy of it.

Updating the brain's *content* is a different act: propose candidates (see
above), or edit exactly the items the human designates.
