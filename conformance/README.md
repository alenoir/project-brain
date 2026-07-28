# Conformance

The executable meaning of "conformant" (see [spec chapter 01](../spec/v0.1/01-conformance.md)). Layer 1: this code defines nothing — it *checks* what the spec defines; where they disagree, the spec wins (Principle P10).

## The validator — available now

[`validate.py`](validate.py) — single file, Python 3 + PyYAML, shipped ahead of the original v0.3 schedule per RFC 0001 (consumer-first).

Run it on any brain:

```sh
# locally, from the repo root
curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/conformance/validate.py | python3 - .brain

# or in CI: copy tools/github-actions/validate-brain.yml to .github/workflows/
```

`--strict` turns warnings into errors. Exit code 0 = conforms to its claimed level.

What it checks today (spec references in every message):

- **Manifest**: required fields, valid conformance level, entry file exists.
- **Every item**: metadata block present, required fields at Level 2+, valid enums (type/status/authority/provenance), ISO dates, id uniqueness and form.
- **Trust model**: `canonical` requires `verified.by`/`at`; notes can't be canonical; `deprecated`/`archived` status forces matching authority.
- **Areas**: `candidates/` items must be candidates and carry no `verified` block (stale candidates flagged); `archive/` items should be archived.
- **Freshness**: `state` requires `review_by`; past-due `review_by` and `expires` flagged.
- **Cross-references**: `superseded_by`/`supersedes`/`relates_to` must resolve.
- **Context (Level 3)**: manifest + default pack required; pack files parse; every pack entry resolves to a real item or directory.

## Still to come (v0.3)

- Fixture corpus: valid and deliberately invalid brains, each annotated with the violated clause — the validator's own regression suite.
- Tool-duty scenarios: Reader/Writer/Validator obligations from chapter 01 as testable assertions.
- The checkable-vs-uncheckable inventory: every MUST of the spec classified.
