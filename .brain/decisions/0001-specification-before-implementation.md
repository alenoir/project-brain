---
id: decision.0001-specification-before-implementation
type: decision
title: The standard is specified before it is implemented
status: draft
authority: candidate
provenance: agent
generator: "founding session, 2026-07-28"
created: 2026-07-28
updated: 2026-07-28
sources:
  - ref: "Founding brief (Mission 1); VISION.md 'Why a standard, and not a product'"
relates_to: [decision.0002-english-working-language]
---

# Decision: specification before implementation

**Context.** The founding brief demands a protocol in the tradition of
OpenAPI/Terraform/Docker: the contract is the product. The opposite path —
ship a tool, extract a spec later — is where brain.md sits, and it forfeits
neutrality (P7, P10).

**Options considered.**
1. Spec-first, tools much later — the original roadmap; market evidence says
   this is the llms.txt death pattern (see prior-art/).
2. Tool-first — rejected: the tool's behavior becomes the de facto standard.
3. Spec-first with day-one minimal consumers — spec remains sole normative
   artifact, but a loader/validator ship alongside it (proposed by RFC 0001).

**Decision.** Option 1 was chosen at founding; RFC 0001 proposes amending the
*sequencing* toward option 3 without touching the primacy of the spec (P10).

**Consequences.**
- This repository contains no code, ever; tools live in Layer 2 repositories.
- Where any tool and the spec disagree, the tool is wrong.
- The credibility burden shifts to the spec's precision — hence the
  conformance levels and the (future) executable conformance suite.
