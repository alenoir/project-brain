---
id: decision.0001-event-sourced-ledger
type: decision
title: The financial ledger is event-sourced
status: active
authority: canonical
provenance: human
created: 2026-01-15
updated: 2026-01-15
verified:
  by: "@sofia"
  at: 2026-01-15
sources:
  - pr: 12
  - ref: "2025 compliance audit, finding F-7 (invoice mutability)"
relates_to: [rule.invoice-immutability, invariant.ledger-append-only]
---

# Decision: event-sourced ledger

**Context.** The 2025 audit (finding F-7) showed we could not prove that issued
invoices had never been modified: the monolith stored them as mutable rows.
EU enterprise contracts require demonstrable immutability.

**Options considered.**
1. Mutable rows + audit-log table — rejected: the audit log is advisory, DBAs can
   still mutate rows; provability is procedural, not structural.
2. Append-only event stream, state derived by projection — chosen.
3. Third-party immutable ledger service — rejected: vendor lock-in on our most
   critical data, and offline reprocessing becomes impossible.

**Decision.** All financial facts are events in an append-only stream
(`src/ledger/`). Invoices, balances, and dunning states are projections.
Corrections are compensating events, never mutations.

**Consequences.**
- Immutability is structural → `invariant.ledger-append-only`.
- Any "edit" feature must be designed as a compensating flow → `rule.invoice-immutability`.
- Projections can be rebuilt; the replayer is load-bearing infrastructure.
- Cost accepted: eventual consistency between write and read models (~seconds).
