# Governance

How the standard itself is governed. (How a *project's brain* is governed is defined by the spec — chapters 06–07.)

## Roles

- **Maintainers** — steward the spec, merge changes, judge RFCs. Initially the founding team; the bar for adding maintainers is sustained, high-quality contribution.
- **Contributors** — anyone. Issues, PRs, RFCs, field reports from real brains.
- **Adopters** — projects running a brain. Their field reports carry special weight: a spec that reads well but maintains badly is a failed spec, and only adopters can tell us.

## Decision rules

1. **Editorial changes** (clarity, typos, examples): one maintainer approval.
2. **Normative changes** (any MUST/SHOULD, field, state, level, protocol): RFC required; consensus of maintainers; minimum comment period of two weeks.
3. **Constitutional changes** (anything conflicting with `PRINCIPLES.md`): the RFC must first amend the principles; all maintainers must approve.
4. Disagreement among maintainers unresolved after discussion defaults to **no change** — a standard's inertia is a feature.

## The RFC process

Defined in [`rfcs/README.md`](rfcs/README.md). In short: substantial ideas enter as numbered RFC documents, are debated in the open, and are merged as *accepted* or *rejected* — both outcomes are recorded permanently. Rejected RFCs with their reasons are part of the standard's own memory.

## Conflicts of interest

Maintainers affiliated with an AI vendor or tool company must disclose it on any RFC where their employer's product is advantaged. Vendor-specific privileges in the spec are constitutionally barred (P7) regardless of disclosure.

## The standard eats its own cooking

This repository maintains its own `.brain/` (from v0.1 exit). Spec changes that make our own brain awkward to maintain are treated as field evidence against the change.
