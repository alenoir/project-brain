# 04 — Knowledge Model

## 4.1 The Knowledge Item

The atomic unit of a Brain is the **Knowledge Item**: one Markdown file with a YAML Metadata Block.

```markdown
---
id: rule.invoice-immutability
type: rule
title: Issued invoices are immutable
status: active
authority: canonical
provenance: human
created: 2026-03-02
updated: 2026-06-14
verified:
  by: "@sofia"
  at: 2026-06-14
sources:
  - path: src/billing/invoice.py
  - pr: 412
tags: [billing, compliance]
---

An invoice, once issued, can never be modified — only credited and re-issued.

This is a legal requirement (EU VAT directive) and an assumption baked into
the ledger design: corrections are new documents, never mutations.

## Consequences
- The `invoices` table is append-only (see invariant.ledger-append-only).
- "Edit invoice" features must be designed as credit-note + reissue flows.
```

Rules:

- An item **MUST** have exactly one Metadata Block, first in the file.
- An item **MUST** declare `id`, `type`, `title`, `status`, `authority` (Level 2+). Full field list: chapter 09.
- An item **SHOULD** express **one** unit of knowledge: one decision, one rule, one invariant, one topic. Small items are citable, verifiable, and deprecable *individually*; omnibus documents are none of these.
- Content is CommonMark. No HTML-dependent, tool-dependent, or vendor-dependent constructs for meaning: an item **MUST** carry its full meaning as plain rendered text.

## 4.2 Identity

- `id` is a stable, human-readable identifier, unique within the Brain: RECOMMENDED form `type.slug` (e.g. `decision.0007-event-sourcing`, `invariant.ledger-append-only`).
- The `id`, not the file path, is the item's identity: items **MUST** keep their `id` when moved (e.g. into `archive/`).
- Cross-references between items **SHOULD** use ids (`see invariant.ledger-append-only`), and MAY additionally use relative links for human navigation.

> *Rationale.* Paths change (promotion, archival, reorganization). Knowledge that cites knowledge needs an identity that survives moves — this is what lets deprecation say `superseded_by: decision.0012-...` reliably.

## 4.3 Knowledge Types

v0.1 defines nine types. Types constrain *expected content* and assign a *precedence class* (chapter 05).

| Type | Question it answers | Expected content | Typical area |
|---|---|---|---|
| `overview` | What is this project and why? | Purpose, scope, non-goals, key vocabulary | root of Brain |
| `state` | Where are we right now? | In-flight work, blockers, freezes, next milestone | `state/` |
| `architecture` | How is it shaped? | Structure, boundaries, key flows, integration points | `architecture/` |
| `decision` | Why is it this way? | Context, options, choice, consequences (ADR-style) | `decisions/` |
| `rule` | What must the domain honor? | One business rule, its rationale, its consequences | `rules/` |
| `invariant` | What must never break? | One constraint, why it exists, what happens if violated | `rules/` |
| `guide` | How do I work here? | Setup, workflow, conventions, testing, review norms | `guides/` |
| `knowledge` | What must one know about the domain? | Domain concepts, external constraints, integrations | `knowledge/` |
| `note` | Everything else | Free-form; the escape hatch | anywhere |

Type-specific normative rules:

- **`decision`** items are immutable in substance once active: fixing typos is allowed; changing the decision is a *new* decision superseding the old (chapter 07).
- **`invariant`** and **`rule`** items **MUST** state exactly one constraint each and **SHOULD** state the consequence of violating it.
- **`state`** items **MUST** carry `review_by` (freshness) metadata; a `state` item past its `review_by` date **MUST** be treated by Readers as `needs-review` (chapter 07) even if not yet flagged.
- **`note`** items **MUST NOT** carry authority `canonical`. If a note becomes load-bearing, it must be reshaped into a proper type.

> *Rationale for a closed type list.* Types carry precedence semantics; open-ended types would make conflict resolution undefined. Projects wanting finer categories use `tags` (free) rather than new types (semantic). New types require an RFC.

## 4.4 Granularity guidance (informative)

- One decision = one file. One invariant = one file.
- `architecture/` and `knowledge/` items should target the 5-minute read; split beyond that.
- The Brain records **what code cannot say**. If a fact is fully expressed by the code and its tests, the Brain should link, not restate — restatement is future drift.
- Prefer updating an existing item over creating a near-duplicate; the Context Budget (P9) is spent by every redundant word.
