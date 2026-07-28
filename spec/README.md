# The Project Brain Specification

This directory contains the normative text of the standard. **Only the spec is normative**; everything else in the repository (README, VISION, GLOSSARY, examples) is informative.

## Versions

| Version | Status | Location |
|---|---|---|
| **v0.1** | **Draft** — under active design, everything may change | [`v0.1/`](v0.1/) |

## Reading order (v0.1)

| Chapter | Contents |
|---|---|
| [00 — Overview](v0.1/00-overview.md) | Scope, goals, non-goals, document conventions |
| [01 — Conformance](v0.1/01-conformance.md) | Conformance levels for brains and for tools |
| [02 — Terminology](v0.1/02-terminology.md) | Normative definitions |
| [03 — Brain Structure](v0.1/03-brain-structure.md) | The Brain Root, the manifest, directory roles |
| [04 — Knowledge Model](v0.1/04-knowledge-model.md) | Knowledge Items and their types |
| [05 — Authority](v0.1/05-authority.md) | Authority levels and conflict precedence |
| [06 — Provenance & Verification](v0.1/06-provenance-and-verification.md) | Origin tracking and the promotion rule |
| [07 — Lifecycle](v0.1/07-lifecycle.md) | States, legal transitions, drift, archive |
| [08 — Context Protocol](v0.1/08-context-protocol.md) | Manifests, packs, intents, agent read/write protocol |
| [09 — Metadata Reference](v0.1/09-metadata.md) | Every field of the metadata block and the manifests |
| [10 — Versioning & Evolution](v0.1/10-versioning.md) | Spec versioning, brain migration, extensions |

## Specification conventions

- The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL** are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).
- Non-normative commentary appears in blockquotes marked *Note* or *Rationale*.
- Examples are non-normative unless stated otherwise.

## Changing the spec

Editorial fixes go through ordinary pull requests. Any change to semantics — fields, levels, states, protocols — goes through the [RFC process](../rfcs/).
