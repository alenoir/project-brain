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

## 6.3 The two trust tiers *(RFC 0002)*

The governance burden is proportional to binding force:

| Tier | Authority | Maintained by | Areas |
|---|---|---|---|
| **Working knowledge** | `candidate`, `informative` | agents directly, humans freely | `state/`, `knowledge/`, `architecture/`, `guides/`, `candidates/` |
| **Binding knowledge** | `canonical` | humans only, via Verification | `rules/`, `decisions/`, any promoted item |

- Agents MAY create and maintain Tier-1 items directly — truthful provenance, `updated` kept current. `informative` binds no one (5.1); creating it therefore requires no ceremony.
- `rules/` and `decisions/` are canonical-bound by nature: agent proposals for them enter via `candidates/` or a promotion proposal — never placed directly.
- Everything in chapter 5 still applies: only `canonical` constrains readers; a Brain rich in informative knowledge is useful context, not binding truth.

## 6.4 Verification paths

Two equivalent ways for a human to sign:

- **Explicit** — a human writes (or instructs a scribe to write) the `verified` block, as in 6.2.
- **Merge-verification** — if the Brain Manifest declares `verification: merge`: a pull request whose description lists the item ids it promotes, once merged by a human, constitutes Verification by the merger; the `verified: {by: <merger>, at: <merge date>}` block is then completed mechanically. Merging **is** signing.

In both paths the invariant of 5.1 is unchanged: `canonical` without a `verified` block is invalid. `verification: explicit` is the default; `merge` is RECOMMENDED for solo maintainers and small teams (spec 9.2).

## 6.5 The promotion flow

The complete life of an agent contribution bound for canonical:

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

- Canonical-bound proposals **MUST** enter via `candidates/` (or a promotion proposal), with `authority: candidate` and truthful provenance (chapter 01).
- Promotion (the move + authority change + verification) **MUST** be performed or approved by a human — explicitly, or by merge-verification (6.4). A tool MAY mechanize the file operations; the *decision* is human.
- Unpromoted candidates do not rot into truth: a candidate older than its `expires` date (RECOMMENDED default: 90 days) **SHOULD** be deleted or archived by maintenance. A stale candidates inbox is a Brain smell.

## 6.6 What agents do without a human

Everything except granting binding trust. A conformant agent maintains the Tier-1 brain as part of ordinary work:

- keeps `state/now.md` true after significant sessions (a **duty**, not a favor — chapter 08);
- records durable findings as informative knowledge, with sources;
- drafts canonical-bound candidates ("the retry logic assumes idempotent consumers — proposing an invariant");
- proposes deprecations and drift flags (candidates referencing the target item);
- assembles, cites, and cross-references existing knowledge.

The line stays bright where it matters: **agents produce and maintain knowledge; humans produce binding truth.** (Principle P4, scoped by RFC 0002.)
