---
name: project-brain
description: Read and respect this project's .brain/ directory (Project Brain standard). Use at the start of any coding, review, or analysis task in a repository containing .brain/brain.yaml, before finishing a significant session to record findings as candidates, and when asked to update or refresh the Project Brain tooling ("update the brain").
---

# Project Brain protocol

This repository carries a brain: governed project knowledge under `.brain/`
(Project Brain standard — https://github.com/alenoir/project-brain). Follow
this protocol instead of ad-hoc exploration.

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

## Writing protocol (end of significant session)

- Distill durable findings — things the next session would otherwise
  rediscover — into `.brain/candidates/<date>-<slug>.md`.
- Front matter MUST include: `id`, `type`, `title`, `status: draft`,
  `authority: candidate`, `provenance: agent`, `created`, `updated`, and
  `sources` citing your evidence (paths, commits, PRs).
- **Never** write elsewhere in `.brain/`, never set authority above
  `candidate`, never write a `verified` block. Humans promote; you propose.
- Prefer proposing an amendment to an existing item (reference its `id`)
  over creating a near-duplicate.

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
