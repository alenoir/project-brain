# Glossary

The vocabulary of Project Brain. This file is **informative**; the normative definitions live in [`spec/v0.1/02-terminology.md`](spec/v0.1/02-terminology.md). Terms are capitalized when used in their technical sense.

---

## Core structure

### Brain
The complete, governed knowledge structure of one project, stored inside that project's repository under the Brain Root. A Brain is made of Knowledge Items, a Brain Manifest, and Context material. One repository normally carries one Brain (monorepos may carry several — see the spec).

### Brain Root
The directory that contains a Brain. By convention `.brain/` at the repository root. Its location is declared, not assumed: the Brain Manifest is what makes a directory a Brain Root.

### Brain Manifest
The machine-readable entry point of a Brain (`brain.yaml`). Declares the spec version, the conformance level claimed, the layout, and where the Context Manifest is. **The manifest is the handshake**: an agent that finds it knows exactly how to read everything else.

### Bridge File
A file that connects today's agent ecosystems to the Brain — typically `AGENTS.md` or `CLAUDE.md` at the repository root containing a pointer into the Brain Root. Bridge Files carry no knowledge of their own; they exist so current tools discover the Brain without native support.

---

## Knowledge

### Knowledge Item
The atomic unit of the Brain: one Markdown file with YAML front matter (its Metadata Block). Every Knowledge Item has a stable identifier, a type, an authority level, a provenance, and a lifecycle status.

### Canonical Knowledge
Knowledge Items with authority `canonical`: statements the project asserts as true and binding. Canonical Knowledge is the ground truth agents must respect. Only Verification can make knowledge canonical (Principle P4).

### Knowledge Candidate
A Knowledge Item that has been *proposed* — typically by an agent after a session, or by a human in passing — but not yet verified. Candidates live in the candidates area, carry authority `candidate`, and bind no one. Candidates are the **only** thing agents may create on their own authority.

### Generated Knowledge
Any knowledge whose provenance is `agent` (or `mixed`). Generated Knowledge may be excellent; it still cannot be canonical until a human verifies it. "Generated" describes origin, not quality.

### Historical Knowledge
Knowledge that was true and no longer is, preserved with status `archived`. The archive is not a trash can: knowing *what used to be true, and until when* prevents the re-litigation of settled questions and the resurrection of dead bugs.

### Current State
A dedicated knowledge type answering "where is the project *right now*": what is in flight, what is blocked, what is frozen, what the next milestone is. The most volatile — and most rot-prone — part of a Brain; the spec gives it explicit freshness metadata.

### Decision / Decision Record
A knowledge type capturing one significant choice: context, options, outcome, consequences. The direct descendant of ADRs, generalized beyond architecture (product, process, and domain decisions are equally recordable) and integrated into the authority and lifecycle model.

### Business Rule
A knowledge type capturing a domain-level rule the software must honor ("an invoice is immutable once issued"). Business Rules state *what must hold* in the domain, independent of implementation.

### Invariant
A knowledge type capturing a constraint that must never be violated, technical or domain ("the ledger table is append-only", "never retry a payment without an idempotency key"). Invariants are the highest-precedence knowledge in conflict resolution: they are the landmines map.

### Guide
A knowledge type capturing *how to work on the project*: setup, workflows, conventions, review expectations, testing philosophy.

### Source
A reference from a Knowledge Item to the material that supports it: a file path, a commit, a PR, an issue, an external document. Sources make knowledge auditable — they are where Provenance points.

---

## Trust model

### Authority
The declared trust level of a Knowledge Item — how strongly it binds readers. The v0.1 scale: `canonical` > `informative` > `candidate` > `deprecated` > `archived`. Authority answers one question a reader must never have to guess: **"how much should I trust this?"**

### Authority Precedence
The total order the spec defines for resolving conflicts between items (by authority level, then by type, then by recency), so that two agents reading the same Brain reach the same conclusion.

### Provenance
Who produced a Knowledge Item: `human`, `agent`, `mixed`, or `imported`. Recorded in metadata, never erased by promotion — a verified item keeps its `agent` provenance forever. Provenance is about honesty; Authority is about trust. The pair is the heart of the governance model.

### Verification
The accountable human act that promotes a Candidate to canonical (or confirms an existing item is still true): recorded in metadata (`verified.by`, `verified.at`) and in Git history. Verification is the *only* path to authority (Principle P4).

### Drift
A detected divergence between the Brain and reality (usually the code). Drift does not silently invalidate knowledge; it must be surfaced — the item gets flagged, re-verified, amended, or deprecated. Naming drift is how the standard confronts documentation rot instead of pretending it away.

---

## Context protocol

### Context
The subset of a Brain actually loaded for a given task. The Brain is the library; Context is what you carry to the desk.

### Context Manifest
The machine-readable index (`context/manifest.yaml`) that maps *intents* — kinds of task — to Context Packs, and declares the default pack. The entry point of the Context Protocol.

### Context Pack
A curated, ordered reading list for one kind of task ("onboarding", "adding a feature", "fixing a production bug", "release"), with required and optional items and priority order. Packs exist because of Principle P9: nobody — human or agent — reads the whole Brain; the Brain must therefore know its own useful subsets.

### Context Budget
The scarcity constraint (attention, tokens, time) under which Context is assembled. The spec does not measure it in tokens — that would age — but every Pack is designed against the assumption that the budget is finite and small.

### Intent
A named kind of task an agent or human arrives with (`onboard`, `feature`, `bugfix`, `refactor`, `release`, …). Intents are the keys of the Context Manifest.

---

## Lifecycle

### Lifecycle
The states a Knowledge Item moves through: `draft` → `active` → (`needs-review`) → `deprecated` → `archived`. Transitions are ordinary Git commits; the spec defines which transitions are legal and who may perform them.

### Promotion
The transition of a Candidate into the canonical body of the Brain, via Verification. Promotion moves the file out of the candidates area and upgrades its authority.

### Deprecation
Marking knowledge as no longer to be relied upon, while keeping it in place with a pointer to its replacement (`superseded_by`). Deprecation is knowledge too.

### Archive
The area and final state for Historical Knowledge. Items are moved, never deleted; their metadata records what invalidated them.

---

## Conformance & governance

### Conformance Level
How much of the standard a Brain adopts. Level 1 (*Minimal*): manifest + overview. Level 2 (*Structured*): typed items with metadata, decisions, rules, state. Level 3 (*Governed*): full lifecycle, verification discipline, context packs. Levels make adoption progressive (Principle P8).

### Conformance Suite
The executable tests (Layer 1) that decide whether a Brain — or a tool — actually conforms. The suite, not any tool's opinion, defines conformance.

### Reference Implementation
The CLI maintained alongside the standard to prove it is implementable. Pedagogically privileged, normatively irrelevant: where it disagrees with the spec, it is wrong (Principle P10).

### RFC
The change process of the standard itself. Any substantial evolution — new knowledge type, new metadata field, new authority level — enters as an RFC in `rfcs/` and is debated before the spec changes.
