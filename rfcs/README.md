# RFCs — how the standard changes

Every substantial evolution of Project Brain starts as an RFC (Request for Comments). The process is deliberately modeled on Rust RFCs and Python PEPs: written proposals, open debate, permanent record — accepted *and* rejected.

## When an RFC is required

- Any normative change: new/changed knowledge type, metadata field, authority level, lifecycle state, protocol step, conformance requirement.
- Any change touching `PRINCIPLES.md` (constitutional — see `GOVERNANCE.md`).

Not required for: editorial fixes, informative guidance, examples, prior-art updates.

## Process

1. **Copy** [`0000-template.md`](0000-template.md) to `rfcs/0000-my-title.md` (keep `0000` until acceptance).
2. **Open a PR.** Discussion happens on the PR. Revise freely.
3. **Comment period**: minimum two weeks after the RFC is declared "final comment" by a maintainer.
4. **Decision** (per `GOVERNANCE.md`):
   - **Accepted** → assigned the next number, merged. The spec change itself lands separately in the next spec version, citing the RFC.
   - **Rejected** → also assigned a number and merged, with the reasons recorded. Rejections are knowledge.
5. RFCs are immutable after merge except for links and errata.

## Index

| # | Title | Status |
|---|---|---|
| [0001](0001-consumer-first-roadmap.md) | Consumer-first roadmap (applies CRITIQUE A1–A3) | Draft |
| [0002](0002-agent-first-trust.md) | Agent-first trust model: two tiers, merge-verification, writer duties | Accepted |

Further RFCs are expected to come out of [`CRITIQUE.md`](../CRITIQUE.md), which lists the open problems of the v0.1 draft (notably A6 graduated verification and A7 monorepo precedence).
