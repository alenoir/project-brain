# Architecture — the four layers

The single most important structural decision in Project Brain is the strict separation of four layers. Confusing them is how standards die: the spec bloats with tool features, tools redefine the spec, and projects end up coupled to software instead of to a contract.

```text
┌─────────────────────────────────────────────────────────────┐
│  Layer 1 — THE STANDARD                (this repository)    │
│  The contract. Normative. Versioned. Vendor-neutral.        │
├─────────────────────────────────────────────────────────────┤
│  Layer 2 — IMPLEMENTATIONS            (other repositories)  │
│  Tools that produce, validate, or consume brains.           │
├─────────────────────────────────────────────────────────────┤
│  Layer 3 — PROJECT CONTENT       (each project's .brain/)   │
│  The actual knowledge of a real project. Owned by it.       │
├─────────────────────────────────────────────────────────────┤
│  Layer 4 — TOOLS & ECOSYSTEM        (anyone, anywhere)      │
│  Editors, linters, CI actions, migrations, viewers.         │
└─────────────────────────────────────────────────────────────┘
```

## Layer 1 — The Standard (this repository)

**What it contains**

- the specification (`spec/`) — the only normative text;
- the vocabulary (`GLOSSARY.md`, `spec/*/02-terminology.md`);
- machine-readable schemas for manifests and metadata (`schemas/`);
- the conformance test suite (`conformance/`) — the executable meaning of "conformant";
- the RFC process (`rfcs/`) — how the standard changes;
- examples of **fictional** projects (`examples/`);
- prior-art analysis (`prior-art/`).

**What it must never contain**

- the memory of any real project (Principle P1);
- code that projects depend on at runtime;
- vendor-specific extensions or prompts;
- the reference implementation itself (it gets its own repository, so its release cadence and bugs never blur into the spec's).

**Who owns it** — the standard's governance (see `GOVERNANCE.md`).

## Layer 2 — Implementations

**What they are** — software that speaks the standard:

- the **reference CLI** (target v0.4): validate a brain, scaffold one, assemble a Context Pack;
- agent integrations: a Claude Code / Cursor / Aider / Codex adapter that detects `brain.yaml` and loads packs;
- CI validators, brain linters, migration tools from ADR/wiki/AGENTS.md.

**Rules that bind them**

- An implementation claims conformance **only** by passing the conformance suite (Layer 1).
- The reference implementation is *pedagogically* privileged, never *normatively* privileged: where it disagrees with the spec, it has a bug (Principle P10).
- Implementations may add features (search, embeddings, UIs) — those features are outside the standard and must degrade gracefully: a brain must remain fully usable without them.

**Who owns them** — anyone. This is the point.

## Layer 3 — Project Content

**What it is** — the `.brain/` directory of a real project: its overview, decisions, rules, state, knowledge, candidates, archive, context packs.

**Rules that bind it**

- The *structure* is specified (directory roles, metadata fields, authority levels, lifecycle).
- The *content* is entirely the project's business. The standard never says what a team should decide, only how a decision is recorded and trusted.
- The content is licensed, secured, and access-controlled by the project, exactly like its code. A private repo has a private brain.

**Who owns it** — the project. Always. This is Principle P1 and it is non-negotiable: no tool, vendor, or standard body ever has rights over a project's brain.

## Layer 4 — Tools & Ecosystem

Everything else: editor plugins, brain visualizers, GitHub Actions, dashboards, doc-site generators that render a brain, IDE panels showing the current Context Pack.

**Rules that bind them** — only one: they consume and produce what the spec defines, and they invent no new *semantics*. A tool may cache, index, embed, or summarize a brain, but the derived artifacts are Layer 4 conveniences — the brain itself remains the single source of truth.

## Decision test

When any question arises about where something belongs, apply this test in order:

1. **Does it change what "conformant" means?** → Layer 1, via RFC.
2. **Is it software that reads/writes brains?** → Layer 2.
3. **Is it knowledge about one real project?** → Layer 3, in that project's repo. Never here.
4. **Is it convenience on top?** → Layer 4.

## This repository's own layout

```text
project-brain/
├── README.md              # entry point
├── VISION.md              # why the standard exists
├── PRINCIPLES.md          # the constitution
├── ARCHITECTURE.md        # this file — the four layers
├── GLOSSARY.md            # full vocabulary (informative; normative terms in spec)
├── ROADMAP.md             # v0.1 → v1.0
├── GOVERNANCE.md          # how the standard is governed
├── CONTRIBUTING.md        # how to contribute
├── CRITIQUE.md            # known limits, open problems
├── LICENSE.md
├── spec/
│   ├── README.md          # spec index, versioning policy
│   └── v0.1/              # the v0.1 draft, chapter by chapter (normative)
├── rfcs/
│   ├── README.md          # RFC process
│   └── 0000-template.md
├── prior-art/
│   └── README.md          # comparisons: AGENTS.md, ADR, C4, arc42, Diátaxis, …
├── examples/
│   ├── README.md
│   └── minimal/           # a fictional project with a Level 1→2 brain
├── schemas/               # v0.2 target — JSON Schemas (placeholder)
├── conformance/           # v0.3 target — conformance suite (placeholder)
└── tools/                 # v0.4 target — pointers only, never the tools themselves
```

Note the deliberate absences: no `src/`, no `package.json`, no CLI. Mission one of this repository is to define, not to code.
