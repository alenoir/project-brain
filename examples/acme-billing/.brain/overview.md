---
id: overview.acme-billing
type: overview
title: What acme-billing is and why it exists
status: active
authority: canonical
provenance: human
created: 2026-01-10
updated: 2026-06-02
verified:
  by: "@sofia"
  at: 2026-06-02
---

# acme-billing

**What.** The service that turns Acme's usage data into legally valid invoices and
collects payment for them: invoice generation, credit notes, payment orchestration
across two PSPs (Stripe, Adyen), dunning.

**Why it exists.** Billing was previously a module inside the monolith; a 2025 audit
found we could not prove invoice immutability, which blocked our EU enterprise deals.
This service exists to make compliance *structural*, not procedural — see
`decision.0001-event-sourced-ledger`.

**What it refuses to be.** Not a general ledger (accounting lives in NetSuite), not a
pricing engine (plans come from `acme-catalog`), not a tax calculator (we call Avalara).

**Key vocabulary.** *Invoice* — a legally issued, immutable document. *Draft invoice* —
a mutable pre-document; becomes an invoice only at issuance. *Ledger* — our append-only
event stream of financial facts. *Dunning* — the retry-and-notify flow for failed payments.

**Where to go next.** Current state: `state/now.md`. The two rules you must never break:
`rules/`. Why the design is what it is: `decisions/`.
