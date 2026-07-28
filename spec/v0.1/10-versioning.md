# 10 — Versioning & Evolution

A standard that cannot evolve dies; a standard that evolves carelessly kills its adopters' investment. This chapter fixes the rules for both directions — and it is written for a ten-year horizon (Principle P11).

## 10.1 Versioning the specification

- The spec uses `MAJOR.MINOR` versions (`0.1`, `0.2`, … `1.0`, `1.1`, `2.0`).
- **Pre-1.0**: anything may change between minors. Brains targeting a pre-1.0 spec accept migration cost.
- **From 1.0**: within a major, changes are **strictly additive** — new OPTIONAL fields, new intents vocabulary, new informative guidance. Nothing that makes an existing conformant Brain non-conformant, and nothing that changes how a Reader must interpret existing constructs.
- Renames, removals, or semantic changes of levels/types/fields/states require a new **major**, and the spec for that major **MUST** ship a migration guide from the previous one.
- Every version of the spec remains permanently published under `spec/vX.Y/`. Old versions are never edited except for errata clearly marked as such.

## 10.2 Versioning a Brain

- Each Brain pins its spec version in the manifest (`spec: "0.1"`).
- A Reader encountering a **newer minor** than it knows **MUST** proceed (additivity guarantees safety), ignoring unknown constructs.
- A Reader encountering a **newer major** than it knows **SHOULD** proceed in degraded, read-only mode and report the mismatch; it **MUST NOT** write.
- A Reader encountering an **older** version it knows **SHOULD** apply that version's rules (they remain published forever).
- Migrating a Brain across majors is an explicit, human-approved act (tooling MAY mechanize it), recorded like any change — in Git.

## 10.3 Evolving through RFCs

Any change to normative semantics — a new type, field, state, level, protocol step — enters through the [RFC process](../../rfcs/):

1. Draft an RFC from the template; open a PR.
2. Discussion; revision; explicit consequence analysis (which principles are touched, what breaks, migration story).
3. Accepted → merged into `rfcs/` with a number; the spec change lands in the *next* version's directory, citing the RFC.
4. Rejected → merged as rejected, with reasons. Rejected RFCs are Historical Knowledge for the standard itself.

The bar scales with blast radius: fixing prose is a PR; adding an optional field is a small RFC; touching authority semantics or the promotion rule (P4) is a constitutional change and must argue against `PRINCIPLES.md` directly.

## 10.4 Extensions

Innovation should not queue behind the RFC process:

- **`x-` fields** (chapter 09) let projects and tools attach any metadata today, without standard blessing, and **MUST** never alter standard semantics.
- Recurring, proven `x-` extensions are the natural feedstock of RFCs — standardize what the ecosystem already validated (the OpenAPI path: `x-` today, core tomorrow).
- Tools may offer capabilities far beyond the spec (search, graphs, dashboards) as long as the Brain remains fully usable without them (Layer rules, `ARCHITECTURE.md`).

## 10.5 The durability contract

What a project investing in a Brain today is promised:

1. **Your files stay readable** — Markdown + YAML, no binary, no runtime, forever parseable by tools that don't exist yet.
2. **Your semantics stay published** — every spec version remains available; the meaning of your metadata can always be looked up.
3. **Additive minors** — no forced migrations within a major.
4. **Migration guides across majors** — investment carries forward.
5. **No vendor can capture it** — the standard names no vendor; your Brain works with whatever agent wins the next decade.
