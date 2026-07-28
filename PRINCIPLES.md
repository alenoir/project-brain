# Principles

These principles are the constitution of Project Brain. Every rule in the specification must be traceable to at least one of them. A proposed change that violates one of them needs an RFC that amends this file first.

## P1 — The brain belongs to the project

The brain of a project lives in that project's repository and nowhere else.
No SaaS, no external store, no sidecar service is ever required to read or write it.
The Project Brain standard repository never contains any real project's memory.

## P2 — Git is the database

Versioning, history, branching, merging, review, and access control are Git's job.
The standard adds no storage layer, no locking, no sync protocol.
If a capability requires more than files in a repository, it is out of scope.

## P3 — Human-readable first, machine-exploitable always

Every knowledge item must be readable by a human with no tooling: Markdown prose, YAML metadata.
Every knowledge item must be exploitable by a machine with no NLP: explicit metadata, deterministic entry points, stable identifiers.
When these two goals conflict, readability of the *content* wins and structure moves to *metadata*.

## P4 — Truth is governed, not generated

Text produced by an agent is a **candidate**, never truth.
Only **verification** — an accountable human act, recorded in metadata and in Git history — promotes knowledge to canonical.
An agent may write everything except authority.

## P5 — Authority is explicit

A reader must never have to guess how much to trust a document.
Every knowledge item declares its authority level; the specification defines a total precedence order for conflicts.
Silence is not canonical: an item without declared authority is informative at best.

## P6 — Knowledge has a lifecycle

Knowledge is proposed, verified, lives, drifts, is deprecated, and is archived — never silently deleted.
"No longer true" is itself knowledge: the archive is part of the brain.

## P7 — Vendor and model neutrality

The standard names no AI vendor, assumes no model, and encodes no prompt.
Any capability that only some agents possess (embeddings, function calling, context size) is excluded from the standard and left to tools.
Bridge files (e.g. `AGENTS.md`) may exist for today's ecosystems, but they point into the brain; they are not the brain.

## P8 — Progressive adoption

A project must be able to adopt the standard in one hour and deepen over years.
Conformance is leveled: a minimal brain (a manifest and an overview) is already conformant.
No rule may make the minimal level harder than writing two files.

## P9 — The context budget is real

Agents and humans both read under scarcity.
The standard must make it possible to load *the right subset* of the brain for a task — this is the role of Context Packs — rather than assuming the whole brain is always read.
Writing for the brain means writing for partial reading.

## P10 — Specification over implementation

The standard is defined by its specification and conformance tests, never by the behavior of any tool — including the reference implementation.
Where a tool and the spec disagree, the tool is wrong.

## P11 — Durability over convenience

Every format choice is evaluated against a ten-year horizon.
Plain text over binary. Explicit over inferred. Boring over clever.
A format feature that saves keystrokes today but requires a live tool to interpret tomorrow is rejected.

## P12 — The brain records, it does not rule

The brain captures what the team knows, decided, and requires.
It never becomes an approval mechanism, a process gate, or a management surface.
If maintaining the brain starts competing with building the project, the brain is being misused — or the standard has failed and must be fixed.
