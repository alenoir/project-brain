# 06 — Provenance & Verification

Provenance is about **honesty** (who produced this text). Verification is about **accountability** (which human stands behind it). Authority (chapter 05) is about **trust**. The three are orthogonal and the standard keeps them so: promotion changes authority, never provenance.

## 6.1 Provenance

Every Knowledge Item declares one `provenance` value:

| Value | Meaning |
|---|---|
| `human` | Authored by a person. |
| `agent` | Authored by an AI agent (any vendor, any model). |
| `mixed` | Substantially co-authored: agent draft with meaningful human editing, or vice versa. |
| `imported` | Brought in from an external system (wiki export, ADR migration, ticket archive). |

Rules:

- Provenance **MUST** be declared at Level 2+; absent, Readers **MUST** assume `agent` (the conservative assumption).
- Provenance is **immutable through promotion**: a verified agent-written item remains `provenance: agent` forever. Rewriting history to hide machine origin is non-conformant.
- An `agent` or `mixed` item MAY record which tool produced it in `generator` (free-form, e.g. `generator: "claude-code"`), for audit only. No semantics attach to specific generator values (Principle P7).
- `imported` items **SHOULD** record their origin in `sources`.

> *Rationale.* In ten years, most text in most brains will be machine-drafted. Pretending otherwise, or discriminating by origin *after verification*, would be both dishonest and useless. What matters is that origin stays visible and that trust is granted by humans — knowingly.

## 6.2 Verification

Verification is the recorded human act that makes knowledge eligible for canonical authority.

```yaml
verified:
  by: "@sofia"          # an accountable identity (handle, email, name)
  at: 2026-06-14        # date of the act
  note: "Checked against billing code and EU VAT rules."   # OPTIONAL
```

Rules:

- `authority: canonical` **REQUIRES** a `verified` block (chapter 05).
- `verified.by` **MUST** identify a human or a named accountable role (`@release-captain`). It **MUST NOT** name an agent or tool.
- Verification attests, at date `at`: *"I checked this; it is true; the project may rely on it."* Re-verification (updating `at`, possibly `by`) is the standard response to doubt, drift flags, or age.
- A substantive edit to a canonical item invalidates its verification: the editor **MUST** either re-verify (they become `verified.by`) or downgrade the item's authority. Cosmetic edits (typos, formatting, link fixes) do not invalidate.
- Git history provides the tamper-evidence: the commit that adds a `verified` block should come from the verifier or their reviewed PR. The spec does not mandate signatures; projects with higher assurance needs MAY layer signed commits on top.

## 6.3 The promotion flow

The complete life of an agent contribution:

```text
 agent session
      │  writes
      ▼
 candidates/summarize-retry-design.md      authority: candidate, provenance: agent
      │
      │  human reviews (ordinary PR review, or in-repo triage)
      ├────────────── reject ─────────────► delete, or archive/ if the rejection
      │                                     itself is worth remembering
      ▼  approve
 move to proper area, e.g. knowledge/retry-design.md
 set authority: canonical (or informative)
 add verified: {by, at}
 provenance stays: agent
```

Rules:

- Writers (agents) **MUST** create items only under `candidates/`, with `authority: candidate` and truthful provenance (chapter 01).
- Promotion (the move + authority change + verification) **MUST** be performed or approved by a human. A tool MAY mechanize the file operations; the *decision* is human.
- Unpromoted candidates do not rot into truth: a candidate older than its `expires` date (RECOMMENDED default: 90 days) **SHOULD** be deleted or archived by maintenance. A stale candidates inbox is a Brain smell.

## 6.4 What agents may do without a human

Everything except granting trust. A conformant agent may — and is encouraged to —:

- draft candidates from a session's findings ("I discovered the retry logic assumes idempotent consumers — proposing an invariant");
- propose deprecations and drift flags (as candidates referencing the target item);
- update its *own* previously written, still-unverified candidates;
- assemble, cite, and cross-reference existing knowledge.

The line is bright: **agents produce knowledge; humans produce truth.** (Principle P4.)
