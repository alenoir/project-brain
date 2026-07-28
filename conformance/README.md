# Conformance suite — v0.3 target

This directory will contain the executable definition of "conformant" (see [spec chapter 01](../spec/v0.1/01-conformance.md)):

- **Brain fixtures** — valid and deliberately invalid brains, each invalid one annotated with the spec clause it violates.
- **Brain checks** — assertions a Validator must produce on each fixture (levels 1–3, authority/verification coupling, lifecycle legality, freshness rules).
- **Tool duties** — Reader/Writer/Validator obligations from chapter 01 expressed as testable scenarios.
- A **CI recipe** projects can copy to validate their own brain on every PR.

Deliberately empty at v0.1. The suite tests a spec that must stabilize first (see [`ROADMAP.md`](../ROADMAP.md)).
