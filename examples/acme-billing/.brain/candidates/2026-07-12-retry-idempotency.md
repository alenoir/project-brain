---
id: candidate.retry-idempotency
type: invariant
title: "Proposed: payment retries require an idempotency key"
status: draft
authority: candidate
provenance: agent
generator: "coding-agent session 2026-07-12"
created: 2026-07-12
updated: 2026-07-12
sources:
  - path: src/payments/retry.py
  - commit: 8f31c2d
  - ref: "incident INC-231 (double charge, 2026-07-08)"
---

While fixing INC-231 I found that `retry.py` re-submits a payment without an
idempotency key when the PSP response times out. Stripe deduplicates by amount
heuristics; **Adyen does not** — this is what double-charged customer 88231.

Proposed invariant: *no payment submission without an idempotency key derived
from the ledger event id.* The fix in commit `8f31c2d` implements this for the
timeout path only; other retry paths (dunning, manual replay) still lack it.

**For the verifier:** please check the dunning path (`src/dunning/collect.py`)
before promoting — I could not confirm its behavior from a test run.
