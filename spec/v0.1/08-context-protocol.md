# 08 — Context Protocol

The Brain is the library; nobody reads the whole library. The Context Protocol defines how a reader — human or agent — goes from *"I have this task"* to *"I have loaded the right knowledge, in the right order, within my budget"*, deterministically.

## 8.1 The Context Manifest

`context/manifest.yaml` maps **Intents** to **Context Packs**:

```yaml
context: 1                       # format marker
default: onboard                 # pack used when no intent matches
packs:
  onboard:
    file: packs/onboard.yaml
    description: First contact with the project.
  feature:
    file: packs/feature.yaml
    description: Designing or implementing new behavior.
  bugfix:
    file: packs/bugfix.yaml
    description: Diagnosing and fixing defects.
  release:
    file: packs/release.yaml
    description: Preparing and shipping a release.
```

Rules:

- A Level 3 Brain **MUST** provide a Context Manifest with at least a `default` pack.
- Intent names are project-chosen. The names above (`onboard`, `feature`, `bugfix`, `refactor`, `release`) are RECOMMENDED as a common vocabulary so tools can match tasks to intents across projects.
- A Reader with a task **MUST** select a pack via the manifest when one exists: the matching intent's pack, else the `default` pack. Ad-hoc exploration MAY *supplement* the pack, never replace it (chapter 01).

## 8.2 Context Packs

A pack is a curated, ordered reading list for one intent:

```yaml
pack: 1
intent: bugfix
description: Diagnosing and fixing defects.
required:                        # MUST be loaded, in this order
  - overview.md
  - state/now.md
  - rules/                      # a directory = all active items within
  - architecture/system-map.md
recommended:                     # SHOULD be loaded if budget allows, in order
  - decisions/0007-event-sourcing.md
  - knowledge/payment-providers.md
on_demand:                       # load when the task touches the matching paths
  - match: "src/billing/**"
    load: [knowledge/invoicing.md, rules/invoice-immutability.md]
  - match: "src/auth/**"
    load: [knowledge/session-model.md]
```

Rules:

- Entries reference items by path relative to the Brain Root, or by `id`. A directory entry means *all `active` items in that directory* (deprecated/archived items are never pulled in by directory expansion).
- **`required`** is a promise in both directions: readers load it entirely; therefore curators **MUST** keep it small. A pack whose required list cannot be read in ~15 minutes by a human is a defective pack (informative guideline).
- **Order is meaning**: lists are ordered by priority, so a budget-constrained reader truncates from the end, never samples randomly.
- `on_demand` rules let packs stay small while covering deep areas: they bind *task surface* (paths the task touches) to *relevant knowledge*.
- Budgets are expressed by **ordering and tiering only** — never in tokens or bytes, which would couple the standard to today's models (Principles P7, P11).

## 8.3 The reading protocol

A conformant Reader entering a repository:

1. **Discover** — find the Brain (Bridge File → `.brain/brain.yaml`, chapter 03). No brain → the protocol ends; behave as before.
2. **Handshake** — parse the manifest: spec version, conformance level, `entry`.
3. **Orient** — read `entry` (the overview).
4. **Select** — determine intent; load the matching or default Context Pack (`required`, then `recommended` as budget allows; arm `on_demand` rules).
5. **Respect** — apply authority semantics (chapter 05): canonical rules and invariants constrain the work; candidates are not truth; conflicts are surfaced.
6. **Deepen** — mid-task, follow `on_demand` triggers and cross-references (`id` citations) as needed.

Steps 1–3 are cheap by construction (three small files). This is the standard's core promise: **from `git clone` to oriented in three reads.**

## 8.4 The writing protocol

A conformant Writer (agent) at the end of a session:

1. MAY distill durable findings — *things the next session would otherwise rediscover* — into Candidates under `candidates/` (chapter 06): `authority: candidate`, truthful `provenance`, `sources` citing the session's evidence (files, commits, PRs).
2. **MUST NOT** write outside `candidates/`, set authority above `candidate`, or write `verified` blocks.
3. **SHOULD** check for an existing item covering the topic and propose an *amendment candidate* (referencing the target `id`) rather than a duplicate.
4. **SHOULD** flag observed drift (chapter 07) via candidates referencing the drifted item.

> *Rationale.* The write protocol is what turns agents from context *consumers* into context *producers* — safely. The inbox pattern (`candidates/`) gives agents a place to be useful without giving them the pen that writes truth.

## 8.5 Humans use the same doors

Nothing in this chapter is agent-only. A new teammate onboards by reading the `onboard` pack; a reviewer checks the `release` pack before shipping. If a pack serves agents but misleads humans, or vice versa, it violates the dual-audience principle (P3) — one brain, one truth, two kinds of reader.
