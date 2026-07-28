---
id: state.now
type: state
title: Where acme-billing stands right now
status: active
authority: canonical
provenance: mixed
created: 2026-02-01
updated: 2026-07-21
review_by: 2026-08-04
review_every: 14d
verified:
  by: "@marc"
  at: 2026-07-21
---

# Now

**In flight**
- Adyen migration, phase 2 of 3: new payments go through Adyen; refunds still on Stripe
  (`PR #402`–`#431`). Target completion: end of August.
- Dunning email templates being localized (FR/DE) — blocked on legal review.

**Frozen — do not touch**
- `src/ledger/**` is frozen until the Adyen migration completes: the ledger replayer
  is the migration's safety net. Exceptions require @sofia.

**Known debt**
- The Stripe webhook handler still assumes at-least-once delivery but not reordering;
  see candidate `2026-07-12-retry-idempotency` (unverified).

**Next milestone**
- `v3.0`: Adyen-only payments, Stripe kept for refund tail. Gate: 30 error-free days.
