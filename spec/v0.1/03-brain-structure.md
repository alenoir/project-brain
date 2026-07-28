# 03 — Brain Structure

## 3.1 The Brain Root

A Brain lives in a single directory, the **Brain Root**.

- The RECOMMENDED location is **`.brain/`** at the repository root.
- A different location is permitted (e.g. `docs/brain/`, or per-package roots in a monorepo) — discovery never depends on the path, only on the presence of `brain.yaml`.
- A Brain Root **MUST** contain a Brain Manifest (`brain.yaml`).
- Everything under the Brain Root belongs to the Brain; the Brain **MUST NOT** claim files outside its root (it may *reference* them as Sources).

> *Rationale.* A dot-directory keeps the brain out of the way of the code while staying at a predictable, top-level, tooling-friendly place — the precedent of `.github/`, `.vscode/`, `.devcontainer/`.

### Discovery

A Reader looking for a Brain **MUST** proceed in this order:

1. a Bridge File at the repository root (`AGENTS.md`, `CLAUDE.md`, …) that names a Brain Root;
2. `.brain/brain.yaml` at the repository root;
3. any `brain.yaml` found by a shallow scan (monorepo case — nearest root wins for a given working path).

## 3.2 The Brain Manifest

`brain.yaml` is the handshake between the project and every tool. Minimal valid manifest (Level 1):

```yaml
brain: 1                 # manifest format marker
spec: "0.1"              # version of this specification
conformance: 1           # claimed conformance level
name: acme-billing
description: Invoicing and payment orchestration service for Acme.
entry: overview.md       # first thing any reader should read
```

Full field reference: chapter 09. The manifest **MUST** be valid YAML, **MUST** declare `spec`, `conformance`, and `entry`, and **SHOULD** stay under fifty lines — it is an index, not a knowledge item.

## 3.3 Standard areas

At Level 2+, the Brain Root uses the following areas. Each area is a directory with a fixed role; all are OPTIONAL except where a conformance level requires their content to exist somewhere.

```text
.brain/
├── brain.yaml            # REQUIRED — the manifest
├── overview.md           # REQUIRED — what & why (type: overview)
├── state/                # Current State (type: state)
│   └── now.md            # RECOMMENDED single entry point for "where are we"
├── architecture/         # structure, boundaries, key flows (type: architecture)
├── decisions/            # Decision Records (type: decision)
├── rules/                # Business Rules & Invariants (types: rule, invariant)
├── guides/               # how to work here (type: guide)
├── knowledge/            # canonical domain knowledge (type: knowledge)
├── candidates/           # Knowledge Candidates — the agent inbox
├── archive/              # Historical Knowledge — never deleted, moved here
└── context/
    ├── manifest.yaml     # Context Manifest
    └── packs/            # Context Pack definitions
```

### Area rules

- **`overview.md`** — exactly one; answers *what is this project, why does it exist, what does it refuse to be*. **SHOULD** be readable in under five minutes.
- **`state/`** — the only area whose content is *expected* to change weekly. Items here **MUST** carry `review_by` freshness metadata (chapter 09). `state/now.md` is the RECOMMENDED aggregate entry point.
- **`decisions/`** — append-mostly. A decision is superseded by a new decision, not edited into a different one (chapter 07). File naming RECOMMENDED: `NNNN-slug.md` with a monotonic number.
- **`rules/`** — the most binding prose in the repository. Invariants **MUST** each be independently stated (one invariant per item) so they can be cited, verified, and deprecated individually.
- **`candidates/`** — the **only** area a conformant Writer may create items in (chapter 01). Structure inside is free; items here bind no one.
- **`archive/`** — items arrive here by *move* with metadata updated (status/authority `archived`); their original identifiers **MUST** be preserved.
- **`context/`** — chapter 08.

### Subdirectories and organization

Within an area, projects MAY organize freely (subdirectories by domain, by component…). Tools **MUST** treat area membership as defined by *path under the area directory*, and type as defined by *metadata*, with metadata winning if they disagree (a validator SHOULD flag the disagreement).

## 3.4 Bridge Files

Until agents support the standard natively, a project **SHOULD** provide a Bridge File at the repository root, containing at minimum:

```markdown
# Agents: this project has a brain

Machine-readable project knowledge lives in `.brain/` (Project Brain standard).
Start with `.brain/brain.yaml`, then follow its `entry` and the context manifest.
Do not write to `.brain/` outside `.brain/candidates/`.
```

A Bridge File **MUST NOT** contain knowledge absent from the Brain — it is a pointer, not a second brain, and it never wins a conflict with the Brain.

## 3.5 Monorepos

A monorepo MAY have one Brain per project plus an umbrella Brain at the root. The umbrella manifest lists children:

```yaml
children:
  - path: packages/billing/.brain
  - path: packages/auth/.brain
```

A child Brain is autonomous; the umbrella **SHOULD** hold only cross-cutting knowledge. For a given working path, the nearest ancestor Brain Root governs.

## 3.6 What does not live in the Brain

- Generated artifacts (API docs from code, coverage reports) — derivable, therefore not knowledge. Reference them as Sources.
- Secrets and credentials — **MUST NOT** appear in a Brain, ever.
- Code documentation that belongs next to the code (docstrings, package READMEs) — the Brain links to it rather than duplicating it. The Brain records *what code cannot say*: intent, decisions, rules, state.
