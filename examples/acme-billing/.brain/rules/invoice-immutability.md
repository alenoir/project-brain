---
id: rule.invoice-immutability
type: rule
title: Issued invoices are immutable
status: active
authority: canonical
provenance: human
created: 2026-01-15
updated: 2026-05-30
verified:
  by: "@sofia"
  at: 2026-05-30
sources:
  - ref: "EU VAT directive 2006/112/EC, art. 233 (integrity of content)"
  - path: src/invoicing/issue.py
relates_to: [decision.0001-event-sourced-ledger]
scope: [src/invoicing/**]
---

An invoice, once issued, can never be modified — only credited and re-issued.

This is a legal requirement and a structural assumption of the ledger design.
Any feature that looks like "editing an invoice" **must** be built as:
credit note (compensating event) + new invoice.

**If violated:** the invoice's legal validity is void, and EU enterprise
contracts (immutability clause) are breached. There is no acceptable violation.
