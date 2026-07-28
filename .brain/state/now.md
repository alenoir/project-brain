---
id: state.now
type: state
title: Where the Project Brain standard stands right now
status: draft
authority: candidate
provenance: agent
generator: "founding session, 2026-07-28"
created: 2026-07-28
updated: 2026-07-28
review_by: 2026-08-25
review_every: 4w
---

# Now

**In flight**
- Spec v0.1 draft complete (chapters 00–10) and awaiting first outside reviews.
- RFC 0001 (consumer-first roadmap, from CRITIQUE A1–A3) is open and awaiting
  a maintainer decision — it would move loader/validator/benchmark much earlier.
- This brain itself is unverified: every item is `candidate` until a human
  maintainer verifies and promotes it (Principle P4, applied to ourselves).

**Decisions pending**
- RFC 0001 accept/reject.
- First two target agents for skill/rules packaging (RFC 0001 open question 1).

**Frozen — do not touch**
- No implementation code in this repository (Mission 1 / `CONTRIBUTING.md`):
  no CLI, no package manifests. Bounded exceptions, documented in
  `tools/README.md`: the bootstrap `install.sh` and the prompt-only
  reference consumers (skills/rules). Tools proper are Layer 2, elsewhere.

**Next milestone**
- v0.1 exit: three unaffiliated people hand-write a Level 1–2 brain from the
  spec alone without unanswerable questions (`ROADMAP.md`).
