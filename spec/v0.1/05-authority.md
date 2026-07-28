# 05 — Authority

Authority answers the reader's first question: **how much should I trust this?** It is the load-bearing wall of the standard: without explicit authority, a brain is just a wiki that happens to live in a repo.

## 5.1 Authority levels

Every Knowledge Item declares exactly one `authority` value:

| Level | Meaning | Binding force |
|---|---|---|
| `canonical` | The project asserts this as true and current. | Readers **MUST** treat it as a constraint on their work. |
| `informative` | Useful context; believed true; not load-bearing. | Readers **SHOULD** consider it; MAY act against it with care. |
| `candidate` | Proposed knowledge; unverified. | Binds no one. **MUST NOT** be presented as truth. |
| `deprecated` | Was canonical or informative; no longer to be relied on. | Readers **MUST NOT** follow it; **SHOULD** follow its `superseded_by`. |
| `archived` | Historical record; preserved for memory. | No current force; valuable for understanding the past. |

Rules:

- Authority **MUST** be declared explicitly at Level 2+. An item with no `authority` field **MUST** be treated as `informative` (silence is never canonical — Principle P5).
- `canonical` **REQUIRES** verification metadata (`verified.by`, `verified.at`) — chapter 06. An item claiming `canonical` without verification is invalid; Readers **MUST** downgrade it to `candidate` and Validators **MUST** flag it.
- `note`-type items **MUST NOT** be `canonical` (chapter 04).

## 5.2 Precedence — resolving conflicts

Two items may contradict each other; a Brain is written by humans over years and will contain tensions. The spec defines a **total precedence order** so every Reader resolves a given conflict the same way.

When two Knowledge Items conflict on a point, the prevailing item is determined by comparing, in order:

1. **Authority level**: `canonical` > `informative` > `candidate`. (`deprecated` and `archived` never prevail on current truth.)
2. **Type class**, for items of equal authority:
   `invariant` > `rule` > `decision` > `architecture` > `state` > `guide` > `knowledge` > `overview` > `note`.
3. **Recency**, for items of equal authority and class: latest `updated` date prevails.
4. Still tied → the conflict is **unresolved**: a Reader **MUST** surface it to the human it works for rather than silently pick.

> *Rationale for the type order.* Invariants are landmine markers — they exist precisely to override everything else. Rules bind the domain; decisions bind design; state describes; guides advise. Descriptive types must never override prescriptive ones.

A Reader that detects a conflict between canonical items **SHOULD** report it even when precedence resolves it — a conflict among canonicals is always a defect in the Brain (see Drift, chapter 07).

## 5.3 The Brain and the code

The code is reality; the Brain is intent and memory. When a canonical item and the code disagree:

- The Reader **MUST NOT** silently prefer either.
- The Reader **MUST** surface the divergence as **Drift** (chapter 07): either the code has violated recorded intent (a bug or an unrecorded decision) or the knowledge has rotted (needs re-verification or deprecation).
- An agent asked to modify code **MUST NOT** knowingly violate a canonical `invariant` or `rule`; if the task seems to require it, the agent **MUST** stop and escalate to a human.

> *Rationale.* This asymmetry — advisory for descriptions, blocking for invariants — is deliberate. Descriptive drift is common and cheap; invariant violation is exactly the class of mistake brains exist to prevent.

## 5.4 The Brain and Bridge Files / external documents

The Brain prevails over any Bridge File, README, wiki, or external document within its scope. Tools **MUST NOT** grant such documents authority semantics; their content is at best `informative`.

## 5.5 Authority is not quality

Authority expresses *institutional trust*, not writing quality or usefulness. An excellent agent-written analysis is still `candidate` until verified; a terse human-verified line is `canonical`. Tools ranking or summarizing content **MUST NOT** conflate stylistic signals with authority.
