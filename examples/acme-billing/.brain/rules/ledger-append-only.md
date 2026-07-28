---
id: invariant.ledger-append-only
type: invariant
title: The ledger event stream is append-only
status: active
authority: canonical
provenance: human
created: 2026-01-15
updated: 2026-01-15
verified:
  by: "@sofia"
  at: 2026-01-15
sources:
  - path: src/ledger/store.py
relates_to: [decision.0001-event-sourced-ledger]
scope: [src/ledger/**, migrations/**]
---

No code path, migration, or operational procedure may UPDATE or DELETE rows in
the ledger event tables. Corrections are new, compensating events.

**Why.** Structural immutability is the compliance guarantee this service exists
to provide (`decision.0001-event-sourced-ledger`). One UPDATE anywhere makes the
whole guarantee unprovable.

**If violated:** projections silently diverge from replay, the audit trail is
broken, and finding the divergence later costs days. Treat any violation as a
sev-1 incident, not a cleanup task.
