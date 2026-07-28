# Example — acme-billing

A fictional invoicing service, showing a **Level 3** brain. Directory below mirrors what would live at the root of the `acme-billing` repository.

```text
acme-billing/
├── AGENTS.md                  # bridge file
└── .brain/
    ├── brain.yaml
    ├── overview.md
    ├── state/now.md
    ├── decisions/0001-event-sourced-ledger.md
    ├── rules/invoice-immutability.md
    ├── rules/ledger-append-only.md
    ├── candidates/2026-07-12-retry-idempotency.md   # agent-written, unverified
    └── context/
        ├── manifest.yaml
        └── packs/bugfix.yaml
```

Walk through the files in that order — it is the discovery order a Reader follows (spec chapter 08).
