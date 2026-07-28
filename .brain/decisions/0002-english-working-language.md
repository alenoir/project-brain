---
id: decision.0002-english-working-language
type: decision
title: English is the working language of the standard
status: draft
authority: candidate
provenance: agent
generator: "founding session, 2026-07-28"
created: 2026-07-28
updated: 2026-07-28
sources:
  - ref: "CONTRIBUTING.md ground rules"
---

# Decision: English as working language

**Context.** The founding brief was written in French; the standard aims at
international adoption across all agent ecosystems and a ten-year horizon.

**Options considered.**
1. French — natural to the founders; caps the reviewer and adopter pool.
2. English — the lingua franca of every comparable standard (OpenAPI, RFC,
   AAIF specs); chosen.
3. Bilingual — doubles maintenance and guarantees drift between versions.

**Decision.** The standard's text is English. Real projects' brains declare
their own `language` in their manifest and may be written in any language —
the spec's metadata stays language-neutral.

**Consequences.**
- Translations of the spec, if any, are informative only.
- Examples use English content; the `language` manifest field exists partly
  so non-English brains are first-class citizens of the standard.
