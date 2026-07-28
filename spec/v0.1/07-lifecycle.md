# 07 — Lifecycle

Knowledge ages. The lifecycle makes aging explicit, so that a Brain rots *visibly* instead of silently — visibility is the whole difference between a brain and a stale wiki.

## 7.1 Status values

Every Knowledge Item declares one `status`:

| Status | Meaning |
|---|---|
| `draft` | Being written; not yet claiming to be complete. |
| `active` | In force; the normal state of live knowledge. |
| `needs-review` | Flagged: doubted, past freshness, or drift-suspected. Still in force, but read with caution. |
| `deprecated` | No longer in force; kept in place, pointing to its replacement. |
| `archived` | Historical; moved to `archive/`. |

`status` (lifecycle position) and `authority` (trust) are distinct axes but constrained: `deprecated`/`archived` status forces the same-named authority; `draft` and `needs-review` items MAY keep their authority (a canonical item under review remains canonical until resolved).

## 7.2 Legal transitions

```text
            draft ──► active ──► needs-review ──► active   (re-verified)
                        │              │
                        │              ├──► deprecated ──► archived
                        │              │
                        └──────────────┴──► archived      (when superseded wholesale)
   candidates:  draft/active(candidate) ──► promoted (ch. 06) or deleted/archived
```

Rules:

- Transitions are ordinary Git commits that update `status` (and `updated`). No transition machinery exists outside the files (Principle P2).
- **No deletion of ever-canonical knowledge.** An item that was once `canonical` **MUST NOT** be deleted; it is deprecated and/or archived. Candidates and drafts MAY be deleted freely.
- `deprecated` items **MUST** carry `superseded_by` (an item `id`) when a replacement exists, and **SHOULD** carry a one-line reason (`deprecation_note`).
- Archival is a *move* to `archive/` preserving `id` and history (`git mv`); the archived item records what invalidated it.
- Transitions touching `canonical` items (deprecating, archiving, re-activating) are trust decisions and **MUST** be human-performed or human-approved, like verification (chapter 06).

## 7.3 Type-specific lifecycles

- **Decisions** are never "updated" into different decisions. Reversing or amending a choice = new `decision` item + old one `deprecated` with `superseded_by`. The chain of superseded decisions **is** the project's reasoning history — this is the ADR discipline, made enforceable.
- **State** items expire by design: each **MUST** carry `review_by`; past that date, Readers **MUST** treat them as `needs-review` even if unflagged (chapter 04). State is the one area where "probably stale" is the default assumption.
- **Invariants and rules** should almost never be deprecated casually — each deprecation **SHOULD** cite the decision that lifted the constraint.

## 7.4 Drift

**Drift** is a recognized divergence between the Brain and reality (usually code).

Handling protocol:

1. **Detection** — by a human, an agent mid-task (chapter 05 obliges surfacing), or tooling (e.g. a validator noticing an invariant's cited file disappeared).
2. **Flagging** — set `status: needs-review` on the affected item with a `review_note` (what diverged, where, seen by whom). Agents flag via a candidate proposing the change if they cannot write to the item's area.
3. **Resolution** — a human either: re-verifies (the Brain was right; reality/bug gets fixed), amends + re-verifies (the Brain was outdated), or deprecates (the knowledge no longer holds).

Drift is normal. A Brain with zero `needs-review` items over months is more likely unread than perfect.

## 7.5 Freshness metadata

Three OPTIONAL fields (REQUIRED on `state`) support rot management:

- `review_by: 2026-09-01` — treat as needing review after this date;
- `expires: 2026-09-01` — treat as void after this date (candidates, temporary freezes);
- `review_every: 90d` — declared cadence, for tooling to compute the next `review_by`.

Readers **MUST** honor `expires` (an expired item binds no one) and **MUST** treat past-`review_by` items as `needs-review`.

## 7.6 Maintenance (informative)

A healthy Level 3 Brain has a light recurring routine — a "brain gardening" pass, human-led, agent-assisted: triage `candidates/`, sweep past-due `review_by`, archive expired freezes, check that recent significant PRs produced decisions or state updates. The standard does not mandate cadence or process; it only guarantees that every one of these questions is *answerable from metadata alone* — which is what makes the routine cheap.
