# Contributing

Thank you for helping build a standard meant to outlive its tools.

## Ground rules

- **English** is the working language of the standard (content of real projects' brains can be in any language — see `language` in the manifest).
- **No code in this repository.** The reference implementation lives elsewhere (from v0.4). This repo holds specification, schemas, conformance fixtures, and examples only.
- **No real project's memory.** Examples are fictional (Principle P1).
- Normative statements use RFC 2119 keywords, and only in `spec/`.

## What we need most right now (v0.1)

1. **Field tests** — hand-write a brain for one of your projects using only the spec. Report every question the spec failed to answer: each one is a bug.
2. **Adversarial reads** — find contradictions between chapters, between spec and principles, or ambiguities two implementers would resolve differently.
3. **Prior-art corrections** — if our analysis of an existing system (`prior-art/`) is outdated or unfair, correct it with sources.

## How to propose a change

| Change | Route |
|---|---|
| Typo, wording, example fix | Pull request |
| New guidance (informative) | Pull request + maintainer review |
| Anything normative | [RFC](rfcs/README.md) first |

## Style

- One idea per paragraph; short files over long ones (we obey our own granularity rules).
- Rationale lives in *Note/Rationale* blockquotes, separated from normative text.
- Examples must be realistic — invoicing, auth, retries — not `foo`/`bar`.
