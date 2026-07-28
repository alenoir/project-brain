#!/bin/sh
# Project Brain bootstrap installer
# https://github.com/alenoir/project-brain
#
# Usage, from anywhere inside the target repository:
#   curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh
#
# Refresh the installed tools (skills, rules) to their latest version:
#   curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh -s -- --update
#
# Also install a weekly GitHub Action that opens a PR when the tools change:
#   curl -fsSL .../install.sh | sh -s -- --auto-update
#
# Creates a Level 1 brain (.brain/), an AGENTS.md bridge file, and agent
# consumers (Claude Code skills; Cursor rule if .cursor/ exists).
# Idempotent: never overwrites an existing file, except tool-owned files
# (the skills and rules it installed) when run with --update. Your knowledge
# (.brain/ content, AGENTS.md) is never overwritten, in any mode.

set -eu

UPDATE=0
AUTO=0
for arg in "$@"; do
  case "$arg" in
    --update|update) UPDATE=1 ;;
    --auto-update) AUTO=1 ;;
  esac
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "project-brain: error: run this inside a git repository" >&2
  exit 1
}
cd "$ROOT"
NAME=$(basename "$ROOT")
TODAY=$(date +%F)

say() { printf '%s\n' "$*"; }

# write_if_absent <path>  (content on stdin)
write_if_absent() {
  wia_path=$1
  if [ -e "$wia_path" ]; then
    say "  skip    $wia_path (already exists)"
    cat >/dev/null
    return 0
  fi
  mkdir -p "$(dirname "$wia_path")"
  cat >"$wia_path"
  say "  create  $wia_path"
}

# write_tool <path>  (content on stdin) — tool-owned file: refreshed on --update
write_tool() {
  wt_path=$1
  if [ -e "$wt_path" ]; then
    if [ "$UPDATE" -eq 0 ]; then
      say "  skip    $wt_path (exists; refresh with --update)"
      cat >/dev/null
      return 0
    fi
    mkdir -p "$(dirname "$wt_path")"
    cat >"$wt_path"
    say "  update  $wt_path"
    return 0
  fi
  mkdir -p "$(dirname "$wt_path")"
  cat >"$wt_path"
  say "  create  $wt_path"
}

say "Installing Project Brain (spec 0.1) into $ROOT"

# ---------------------------------------------------------------- .brain/
write_if_absent .brain/brain.yaml <<EOF
brain: 1
spec: "0.1"
conformance: 1
name: $NAME
description: TODO one line on what this project does.
entry: overview.md
EOF

write_if_absent .brain/overview.md <<EOF
---
id: overview.$NAME
type: overview
title: What $NAME is and why it exists
status: draft
authority: informative
provenance: human
created: $TODAY
updated: $TODAY
---

# $NAME

**What.** TODO: what this project does, in a few sentences.

**Why it exists.** TODO: the problem it solves; why it was built.

**What it refuses to be.** TODO: explicit non-goals.

**Key vocabulary.** TODO: the 3-5 domain terms a newcomer must know.

**Where to go next.** Current state: \`state/now.md\`. Rules that must never
break: \`rules/\`. Why things are the way they are: \`decisions/\`.
EOF

write_if_absent .brain/state/now.md <<EOF
---
id: state.now
type: state
title: Where $NAME stands right now
status: draft
authority: informative
provenance: human
created: $TODAY
updated: $TODAY
review_by: $(date -d '+14 days' +%F 2>/dev/null || date -v+14d +%F 2>/dev/null || echo "$TODAY")
---

# Now

**In flight** — TODO: what is being worked on.

**Frozen — do not touch** — TODO: areas that must not change right now, and why.

**Next milestone** — TODO.
EOF

mkdir -p .brain/decisions .brain/rules .brain/candidates
say "  ensure  .brain/decisions/ .brain/rules/ .brain/candidates/"

# ---------------------------------------------------------------- AGENTS.md
BRIDGE_BODY='Machine-readable project knowledge lives in `.brain/` (Project Brain
standard — https://github.com/alenoir/project-brain).

- Start with `.brain/brain.yaml`, then follow its `entry` (`.brain/overview.md`).
- Canonical rules and invariants in `.brain/rules/` are binding.
- Write your findings only to `.brain/candidates/` — never elsewhere in `.brain/`.
- To update the Project Brain tooling of this repo ("update the brain"), run
  `curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh -s -- --update`
  — do not clone the standard'"'"'s repository.'

if [ -e AGENTS.md ]; then
  if grep -q '\.brain/' AGENTS.md; then
    say "  skip    AGENTS.md (already references .brain/)"
  else
    printf '\n## This project has a brain\n\n%s\n' "$BRIDGE_BODY" >>AGENTS.md
    say "  append  AGENTS.md (brain section)"
  fi
else
  printf '# Agents: this project has a brain\n\n%s\n' "$BRIDGE_BODY" >AGENTS.md
  say "  create  AGENTS.md"
fi

# ------------------------------------------------- Claude Code skill
write_tool .claude/skills/project-brain/SKILL.md <<'EOF'
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
EOF

# ------------------------------------------------- brain-init bootstrap skill
write_tool .claude/skills/brain-init/SKILL.md <<'EOF'
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

Create, with today's date and truthful front matter
(`provenance: agent`, `status: draft`, `authority: candidate`,
`generator: "<your tool name>"`, `sources` on every claim):

1. `.brain/brain.yaml` — `brain: 1`, `spec: "0.1"`, `conformance: 1`,
   `name`, one-line `description`, `entry: overview.md`.
   (If a scaffolded brain with TODO placeholders exists — from `install.sh` —
   replace the placeholders with real content instead of skipping.)
2. `.brain/overview.md` — what / why / non-goals / key vocabulary /
   where-to-go-next. Target: readable in 5 minutes.
3. `.brain/state/now.md` — derived from recent history: active work themes,
   apparent freezes, obvious debt. `review_by`: 14 days out.
4. `.brain/decisions/NNNN-*.md` — only decisions with *discoverable*
   rationale (ADRs to import, explained migrations, commit messages that
   argue). One decision per file. Do not invent context you don't have.
5. `.brain/rules/*.md` — candidate invariants and business rules you can
   *evidence* (from tests, comments like "do not", incident fixes, defensive
   code). One constraint per file, with its `sources` and the consequence of
   violating it. These are the most valuable items you can produce — and the
   most dangerous if wrong, hence candidates.
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
EOF

# ------------------------------------------------- Cursor rule (if Cursor used)
if [ -d .cursor ]; then
  write_tool .cursor/rules/project-brain.mdc <<'EOF'
---
description: Project Brain protocol — read and respect .brain/ (Project Brain standard)
alwaysApply: true
---

This repository carries a brain: governed project knowledge under `.brain/`
(Project Brain standard). Before working:

1. Read `.brain/brain.yaml`, then its `entry` file (normally `.brain/overview.md`).
2. If `.brain/context/manifest.yaml` exists, load the pack matching your task
   intent (else the `default` pack): all `required` items in order, then
   `recommended` as budget allows; honor `on_demand` path triggers before
   editing matching files. Otherwise read `overview.md`, `state/now.md`, and
   all of `rules/`.
3. `authority: canonical` items are ground truth — never knowingly violate a
   canonical invariant or rule; stop and ask the human instead. `candidate`
   items are unverified proposals, not truth. Items past `review_by` are stale.
4. If code contradicts a canonical item, flag the drift — do not silently
   pick a side.
5. Record durable session findings only in `.brain/candidates/` with front
   matter `authority: candidate`, `provenance: agent`, and `sources`. Never
   write elsewhere in `.brain/`, never set higher authority, never write
   `verified` blocks. Humans promote; you propose.
6. "Update the brain" / "update the brain tools" means: run
   `curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh -s -- --update`
   from the repo root. Never clone the standard's repository for this.
EOF
else
  say "  skip    .cursor/rules/ (no .cursor/ directory — not a Cursor project)"
fi

# ------------------------------------------------- auto-update workflow (opt-in)
if [ "$AUTO" -eq 1 ]; then
  write_tool .github/workflows/update-project-brain-tools.yml <<'EOF'
# Weekly automatic refresh of the Project Brain tool files (skills/rules).
# Opens a pull request when the tools changed upstream — never commits
# directly, never touches your knowledge (.brain/ content, AGENTS.md).
#
# Requires, in your repository settings (Settings -> Actions -> General):
#   "Allow GitHub Actions to create and approve pull requests" — enabled.

name: Update Project Brain tools

on:
  schedule:
    - cron: "17 6 * * 1" # Mondays 06:17 UTC
  workflow_dispatch: {}

permissions:
  contents: write
  pull-requests: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Refresh Project Brain tools
        run: |
          curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh -s -- --update

      - name: Open a pull request if anything changed
        uses: peter-evans/create-pull-request@v6
        with:
          branch: chore/update-project-brain-tools
          title: "chore: update Project Brain tools"
          commit-message: "chore: update Project Brain tools (install.sh --update)"
          body: |
            Automated refresh of the Project Brain tool files (agent skills and rules)
            from https://github.com/alenoir/project-brain.

            - Only tool-owned files are touched; knowledge in `.brain/` and `AGENTS.md` never is.
            - Review the diff like any dependency update, then merge.
          labels: dependencies
EOF
  say "  note    enable 'Allow GitHub Actions to create and approve pull requests'"
  say "          in Settings -> Actions -> General for the auto-update PRs to open."
else
  say "  hint    add --auto-update to install a weekly PR-based tools refresh"
fi

say ""
say "Done. Your repository is a Level 1 brain (Project Brain spec 0.1)."
say ""
say "Recommended next step — let your agent do the rest:"
say "  open your coding agent (e.g. Claude Code) in this repo and say:"
say ""
say "      init the brain"
say ""
say "  The brain-init skill will analyze the code, git history, and existing"
say "  docs, then fill .brain/ with real content — all marked candidate."
say "  You review the diff, fix what's wrong, and promote what's true by"
say "  setting authority: canonical with a verified block:"
say "      verified:"
say "        by: \"@you\""
say "        at: $TODAY"
say ""
say "Manual alternative: fill the TODOs in .brain/overview.md and"
say ".brain/state/now.md yourself, then commit."
say ""
say "Spec and examples: https://github.com/alenoir/project-brain"
