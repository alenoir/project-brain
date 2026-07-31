---
name: brain-init
description: Bootstrap a Project Brain (.brain/) for this repository by analyzing its code, git history, and existing docs, then generating the brain content as verifiable candidates. Use when the user asks to initialize, install, create, or bootstrap a brain / Project Brain on a repository.
---

# brain-init — agent-driven brain bootstrap

You are about to give this repository a brain (Project Brain standard, spec 0.1
— https://github.com/alenoir/project-brain). You do the work; the human only
verifies. Everything you generate is `provenance: agent` and at most
`authority: candidate` — never `canonical`, never a `verified` block.

## Step 1 — Investigate (before writing anything)

Build real understanding from:
- **Structure**: top-level layout, build files, entry points, module boundaries.
- **Existing knowledge**: README, docs/, CLAUDE.md, AGENTS.md, .cursor/rules,
  ADRs (docs/adr, doc/architecture/decisions…), CONTRIBUTING. These are your
  richest sources — a brain *absorbs* them, it does not duplicate the code.
- **Git history**: `git log` for project age, cadence, recent themes; large or
  reverted changes often mark decisions and landmines.
- **Tests and CI**: what is protected reveals what matters.

## Step 2 — The golden rule of content

Record **only what the code cannot say**: intent, constraints, history, state.
Do NOT restate what any reader can derive from the code itself — generated
restatement is proven to make agents *worse*, not better. Few high-value
items beat many mediocre ones. If you are not confident about a "why",
write the open question into the item rather than inventing a rationale.

## Step 3 — Generate

Create, with today's date and truthful front matter (`provenance: agent`,
`generator: "<your tool name>"`, `sources` on every claim). Authority follows
the two tiers (RFC 0002): **Tier-1 content (overview, state, knowledge,
architecture, guides) goes directly in place at `authority: informative`,
`status: active`** — immediately loadable context, no human queue. Only
canonical-bound proposals (rules, invariants, decisions) go under
`candidates/` at `authority: candidate` awaiting promotion:

1. `.brain/brain.yaml` — `brain: 1`, `spec: "0.1"`, `conformance: 1`,
   `name`, one-line `description`, `entry: overview.md`.
   (If a scaffolded brain with TODO placeholders exists — from `install.sh` —
   replace the placeholders with real content instead of skipping.)
2. `.brain/overview.md` — what / why / non-goals / key vocabulary /
   where-to-go-next. Target: readable in 5 minutes.
3. `.brain/state/now.md` — derived from recent history: active work themes,
   apparent freezes, obvious debt. `review_by`: 14 days out.
4. `.brain/candidates/decision-*.md` — proposed Decision Records: only
   decisions with *discoverable* rationale (ADRs to import, explained
   migrations, commit messages that argue). One decision per file. Do not
   invent context you don't have. (Imported ADRs with clear human authorship
   MAY go directly to `decisions/` with `provenance: imported`,
   `authority: informative`, pending promotion.)
5. `.brain/candidates/rule-*.md` — proposed invariants and business rules
   you can *evidence* (from tests, comments like "do not", incident fixes,
   defensive code). One constraint per file, with `sources` and the
   consequence of violating it. These are the most valuable items you can
   produce — and the most dangerous if wrong, hence candidates: they only
   become binding when a human promotes them into `rules/`.
6. `AGENTS.md` at repo root (or append a brain section if it exists):
   pointer into `.brain/`, candidates-only write rule.
7. If existing ADRs were found: import them under `.brain/decisions/` with
   `provenance: imported` and `sources` pointing at the originals.

## Optional — deep backfill (when the human asks to "mine the history")

By default you work from the current state plus salient history. On request,
backfill the full git history — structured, never commit-by-commit:

1. **Map eras**: tags/releases, major merges, rewrites and renames
   (`git log --stat` at boundaries). Eras give the archive its shape.
2. **Mine decision signals, not everything**:
   - `git log --grep -i -E "revert|rollback|because|instead of|workaround|do not|breaking|migrat"` —
     commits whose messages *argue* are decision records waiting to happen;
   - reverts and re-reverts: each is a lesson (what was tried, abandoned, why);
   - `git blame` on defensive code, odd constants, disabled tests;
   - if you can read PRs/issues (gh, MCP), their descriptions and review
     threads are the richest rationale source — cite them in `sources`.
3. **Produce per era**: at most a handful of high-value candidates —
   `decisions/` with commit/PR sources, `archive/` items for what was true
   and no longer is (historical knowledge), and open questions for every
   "why" you could not evidence.
4. **Scale rule**: on large histories, backfill one era or one subsystem per
   session, newest first — recent history pays off most. A fabricated "why"
   is worse than a recorded open question, always.

## Step 4 — Report for verification

End with a promotion checklist for the human, item by item:
- what you generated and your confidence in it;
- what needs checking before setting `authority: canonical` + a `verified`
  block (`by: "@handle"`, `at: date`);
- the open questions you could not answer from the repository alone —
  these are exactly the knowledge that would otherwise die with the team.

Do not commit unless asked. The human reviews the diff: that review *is*
the standard's promotion flow.
