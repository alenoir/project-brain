# Agents: this project has a brain

Machine-readable project knowledge lives in [`.brain/`](.brain/) (Project Brain standard, spec 0.1).

- Start with `.brain/brain.yaml`, then its `entry` (`overview.md`).
- Select context via `.brain/context/manifest.yaml` for your task.
- Canonical rules and invariants in `.brain/rules/` are binding.
- Write your findings only to `.brain/candidates/` — never elsewhere in `.brain/`.
