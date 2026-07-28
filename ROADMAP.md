# Roadmap

From draft to a standard that deserves trust. Versions are milestones of the **standard** (Layer 1); tooling milestones exist only to prove the standard.

## v0.1 — Minimal specification *(current)*

**Goal: the ideas, precisely written.**

- [x] Founding documents: vision, principles, four-layer architecture
- [x] Full vocabulary (glossary + normative terminology)
- [x] Spec draft: structure, knowledge model, authority, provenance/verification, lifecycle, context protocol, metadata, versioning
- [x] Conformance levels 1–3 defined
- [x] Prior-art analysis
- [x] Self-critique published (`CRITIQUE.md`)
- [ ] First outside reviews; RFC process exercised at least once
- [ ] **Dogfood: this repository maintains its own `.brain/`**

**Exit criterion:** three unaffiliated people have each hand-written a Level 1–2 brain for a real project from the spec alone, without asking questions the spec couldn't answer.

## v0.2 — Schemas

**Goal: the spec becomes machine-checkable.**

- JSON Schemas for `brain.yaml`, the Metadata Block, `context/manifest.yaml`, pack files (`schemas/`)
- Canonical example corpus: valid and *deliberately invalid* brains as fixtures
- Chapter 09 rewritten to defer to schemas; prose keeps rationale only
- Spec corrections harvested from v0.1 field feedback (pre-1.0: breaking allowed)

**Exit criterion:** every example in this repo validates; every fixture invalid for a documented reason fails for that reason.

## v0.3 — Conformance suite

**Goal: "conformant" stops being an opinion.**

- Executable conformance suite (`conformance/`): brain-level checks (levels 1–3) and tool-level check descriptions (Reader / Writer / Validator duties as testable assertions)
- Drift and lifecycle rules covered (e.g. canonical-without-verification must be flagged)
- CI recipe projects can copy to validate their brain on every PR

**Exit criterion:** the suite, run on the example corpus, encodes every MUST of the spec that is mechanically checkable — and lists the ones that are not.

## v0.4 — Reference CLI

**Goal: prove implementability; lower adoption cost. (Separate repository.)**

- `brain init` (scaffold Level 1), `brain validate` (levels + schemas), `brain pack <intent>` (assemble a Context Pack deterministically), `brain triage` (candidates inbox, promotion mechanics — decision stays human), `brain gc` (expired candidates, past-due reviews)
- Zero runtime dependency for consumers: the CLI is convenience, never requirement (P10)

**Exit criterion:** the CLI passes the v0.3 suite; a project can adopt Level 2 in an afternoon with it.

## v0.5 — Migration & bridges

**Goal: meet projects where they are.**

- Migration guides + tooling: existing ADRs → `decisions/`, wiki exports → `imported` knowledge, AGENTS.md/CLAUDE.md content → brain + Bridge File
- Bridge-file generators for today's agent ecosystems (Claude Code, Cursor, Codex, Aider, Gemini CLI, OpenCode…)
- Two to five real adopter projects documented as case studies (with their permission; their brains stay theirs — P1)

**Exit criterion:** a mature repo with years of ADRs and a wiki can reach Level 2 in under a week, mostly mechanically.

## v1.0 — Stable standard

**Goal: the durability contract activates.**

- All spec issues from field usage resolved via RFC
- Additivity guarantee begins (spec 10.1): no breaking changes within 1.x
- Governance hardened: named maintainers, decision rules, versioned publication
- Formal spec text frozen and published; errata process only

**Exit criterion:** at least one agent tool *not built by us* consumes brains natively, and at least ten real projects run Level 2+ in production development.

## Beyond 1.0 (exploratory, unscheduled)

- Standard intents vocabulary extension; cross-repo brain federation (org-level knowledge); signed verification profiles for regulated environments; brain metrics (staleness dashboards) as tooling conventions.

## Anti-roadmap

Things we will not do, at any version: hosted service, vector database, vendor-specific fields, replacing code review, or letting the reference CLI define semantics.
