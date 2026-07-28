# RFC 0001 — Consumer-first roadmap

- **Status**: Draft — awaiting maintainer decision
- **Author(s)**: founding session (agent-drafted, from `CRITIQUE.md` A1–A3)
- **Created**: 2026-07-28
- **Spec version targeted**: none (roadmap change only; no normative spec text changes)

## Summary

Invert the roadmap's center of gravity: minimal consuming/validating tooling ships *alongside* the early spec versions instead of after them (CLI at v0.4). Concretely: (A1) a bridge-file generator, a minimal context-pack loader packaged as drop-in skills/rules for today's major agents, and the validator move to v0.1–v0.2; (A2) a published benchmark — {no context | AGENTS.md | brain + packs} on identical tasks — becomes a v0.2–v0.3 deliverable; (A3) distribution via existing agents' extension mechanisms becomes the primary adoption channel, moved from v0.5 to v0.2.

## Motivation

The market record (see `prior-art/README.md`) is unambiguous:

- **llms.txt**: ~10% deployment on large domains, ~97% of files never read by any AI crawler, no provider commitment — a format without a committed consumer is a dead letter.
- **ai-context-standard**: spec-first, tool-never; dead within weeks.
- **planning-with-files**: the one runaway repo-native success (25.8K stars in ~7 months) shipped as a drop-in skill for 60+ existing agents, with zero adoption ceremony.
- **ETH Zurich (Feb 2026)**: context files are not automatically beneficial; curated + selectively loaded context is. Our value claim is therefore *measurable* — and unmeasured claims in this genre default to disbelieved.

Our current roadmap reproduces the losing sequencing. The precedent we invoke (OpenAPI) actually supports the inversion: Swagger tooling existed *before* the spec generalized.

## Design

Roadmap changes only:

- **v0.1** adds: bridge-file generator (brain → `AGENTS.md`) and a minimal loader (reads `brain.yaml`, resolves the intent's pack, emits the reading list) distributed as skills/rules for at least two major agents.
- **v0.2** adds: validator (levels 1–3 + schemas) — moved up from v0.3; distribution channel work — moved up from v0.5.
- **v0.2–v0.3** adds: the published benchmark (A2), with a pre-registered protocol and the explicit acceptance that a negative result is publishable and actionable.
- **v0.4** becomes the *full* reference CLI (triage, gc), building on the already-shipped pieces.

Layer discipline is unchanged: all tooling lives in Layer 2 repositories; the spec remains the sole normative artifact (P10).

## Principles check

- **P10 (specification over implementation)** — untouched: tools ship earlier but still never define semantics.
- **P8 (progressive adoption)** — reinforced: day-one consumers lower the adoption cliff.
- **P12 (the brain records, it does not rule)** — the benchmark guards against building ceremony that doesn't pay for itself.
- No principle requires amendment; this is sequencing, not semantics.

## Impact

- **On existing brains** — none (no normative change).
- **On tools** — creates the first ones earlier; no interface changes.
- **On conformance levels** — unchanged.
- **Migration** — none.

## Alternatives considered

- **Do nothing (spec-first purity)**: rejected — it is the documented death pattern of this genre.
- **Tool-first (ship a product, extract a spec later)**: rejected — reproduces brain.md's position and forfeits the standard's neutrality claim (P7, P10).
- **Partner-first (wait for an agent vendor to commit)**: attractive but not actionable; vendor interest is likelier once a loader demonstrably works.

## Open questions

1. Which two agents to target first for the skill/rules packaging?
2. Benchmark task suite: SWE-bench-style issue resolution, or maintenance-oriented tasks (where brains should shine most)?
3. Does the minimal loader live in one repository or per-agent repositories?
