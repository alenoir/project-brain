# 00 — Overview

**Project Brain Specification, v0.1 (Draft)**

## 0.1 Abstract

This specification defines a vendor-neutral, repository-native structure — a **Brain** — through which a software project records its knowledge (purpose, architecture, decisions, rules, state, domain knowledge) in a form that is simultaneously readable by humans and deterministically exploitable by AI agents, with explicit trust semantics (authority), origin tracking (provenance), a governed lifecycle, and a protocol for assembling task-scoped context.

## 0.2 Scope

This specification defines:

1. the **structure** of a Brain: its root, its manifest, the role of each area;
2. the **knowledge model**: the Knowledge Item, its types, its metadata;
3. the **trust model**: authority levels, precedence, provenance, verification;
4. the **lifecycle**: states, legal transitions, deprecation, archival, drift handling;
5. the **context protocol**: how readers discover the Brain, select context for a task, and how agents may contribute knowledge back.

## 0.3 Out of scope

The following are explicitly outside this specification, permanently or for v0.1:

- **Retrieval mechanics** — embedding, indexing, ranking, search. Tools may build these; the Brain must remain fully usable without them.
- **Prompting** — how an agent phrases the Brain's content to a model.
- **Enforcement** — CI gates, hooks, review policies. Projects choose their own discipline; the spec only makes discipline *expressible*.
- **Knowledge content** — what a project should decide or know. The spec governs form and trust, never substance.
- **Storage beyond Git** — databases, services, sync. (Principle P2.)
- **Access control** — the repository's own visibility and permissions apply, unchanged.

## 0.4 Audience

Three audiences, in priority order:

1. **Project maintainers** who write and govern a Brain by hand.
2. **Agent and tool authors** who implement readers, writers, validators.
3. **Standard contributors** who evolve this specification.

## 0.5 Design constraints

Normative summary of the constraints every rule in this spec obeys (full rationale in `PRINCIPLES.md`):

- A Brain **MUST** be fully functional as plain files in a Git repository, offline, with no tool installed.
- Every normative construct **MUST** be expressible in Markdown (content) and YAML (metadata).
- No construct **MAY** reference a specific AI vendor, model, or tool.
- A minimal conformant Brain **MUST** be creatable by hand in under an hour (Level 1, see chapter 01).
- Agent-produced text **MUST NOT** be able to reach canonical authority without human verification (chapter 06).

## 0.6 Document map

| Chapter | Question it answers |
|---|---|
| 01 Conformance | What does it mean to conform, for a brain and for a tool? |
| 02 Terminology | What do the words mean, normatively? |
| 03 Brain Structure | Where do files live and what is each area for? |
| 04 Knowledge Model | What is a Knowledge Item and what types exist? |
| 05 Authority | How much do I trust an item; who wins a conflict? |
| 06 Provenance & Verification | Where did this come from; how does it become true? |
| 07 Lifecycle | How does knowledge age, die, and get remembered? |
| 08 Context Protocol | What do I load for this task; how do agents write back? |
| 09 Metadata Reference | Every field, exactly. |
| 10 Versioning & Evolution | How do spec and brains evolve without breaking? |
