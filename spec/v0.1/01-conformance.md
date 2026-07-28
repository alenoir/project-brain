# 01 — Conformance

## 1.1 Conformance targets

This specification defines conformance for two kinds of subject:

- a **Brain** — the `.brain/` content of a project (Layer 3);
- a **Tool** — software that reads or writes Brains (Layers 2 and 4).

## 1.2 Brain conformance levels

Conformance is progressive (Principle P8). A Brain declares its claimed level in its manifest (`conformance` field, chapter 09). A Brain **MUST NOT** claim a level whose requirements it does not meet.

### Level 1 — Minimal

A Level 1 Brain **MUST**:

- have a Brain Root containing a valid Brain Manifest (`brain.yaml`) declaring `spec` and `conformance: 1`;
- contain an `overview.md` Knowledge Item stating what the project is and why it exists.

That is all.

> *Rationale.* Level 1 is deliberately trivial: two files, one hour, immediate value ("an agent that clones this repo knows what it is looking at"). Adoption dies at the first cliff; there must be no cliff.

### Level 2 — Structured

A Level 2 Brain **MUST** additionally:

- give every Knowledge Item a Metadata Block with the REQUIRED fields (chapter 09);
- use the standard knowledge types (chapter 04) and standard directory roles (chapter 03);
- record significant decisions as Decision Records;
- maintain a Current State item with freshness metadata;
- declare authority explicitly on every item (chapter 05).

### Level 3 — Governed

A Level 3 Brain **MUST** additionally:

- enforce the candidate/verification flow: all agent-produced items enter as Candidates and reach canonical authority only through recorded Verification (chapter 06);
- follow the lifecycle rules, including deprecation with `superseded_by` and archival instead of deletion (chapter 07);
- provide a Context Manifest with at least a default Context Pack (chapter 08);
- keep provenance accurate on every item.

## 1.3 Tool conformance

### Reader (consuming tool)

A conformant Reader **MUST**:

1. discover a Brain only via its Brain Manifest (never by guessing at file layout);
2. respect declared authority: treat `canonical` items as binding constraints on its output, and **MUST NOT** present `candidate`, `deprecated`, or `archived` content as current truth;
3. apply the precedence order of chapter 05 when items conflict;
4. when a Context Manifest exists, select context through it (chapter 08) rather than by ad-hoc scanning — ad-hoc reading MAY supplement a pack, not replace it;
5. degrade gracefully: a Brain at any conformance level, or with unknown OPTIONAL fields, **MUST** still be readable (unknown fields are ignored, never errors).

### Writer (producing tool / agent)

A conformant Writer **MUST**:

1. write agent-produced knowledge only as Candidates, with provenance `agent` (or `mixed`);
2. never set, raise, or fabricate authority, and never write `verified.*` fields;
3. produce items valid against the metadata rules of chapter 09;
4. record sources for claims wherever a source exists.

### Validator

A conformant Validator **MUST** check a Brain against the requirements of its *claimed* level and report violations without modifying content.

## 1.4 Conformance suite

From v0.3 of this standard, the conformance suite in `conformance/` is the operational definition of the rules above. Where prose and suite disagree, the prose of the specification prevails and the suite has a bug — which **MUST** be fixed via ordinary contribution, not by reinterpreting the prose.
