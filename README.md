# Project Brain

**An open standard for turning any Git repository into a durable, portable project brain — readable by humans, exploitable by AI agents.**

> Status: **Draft** — specification v0.1 in progress. Nothing here is stable yet.
> This repository defines the **standard**. It never contains the memory of any real project.

---

## The problem

A repository today contains code, a README, and — if you are lucky — some documentation.
Everything else evaporates:

- **decisions** live in closed pull requests and dead Slack threads;
- **constraints** live in the heads of people who leave;
- **domain knowledge** is rediscovered, badly, at every incident;
- **project state** ("where are we, what is in flight, what is off-limits") exists nowhere.

Humans pay this cost slowly. AI agents pay it **every session**: they reconstruct context from scratch, guess at intent, and repeat mistakes the team already paid for.

## The idea

After a plain `git clone`, any human or any agent should be able to understand:

- what the project does and **why it exists**;
- its architecture and its boundaries;
- its business rules and invariants;
- the decisions that were made, and why;
- its current state and active constraints;
- how to work on it.

Without a SaaS. Without an external memory. Without a specific AI vendor.

**The brain lives with the project.** It is versioned with the code, reviewed with the code, merged with the code, and it travels wherever the repository travels.

## What Project Brain is

Project Brain is:

- a **specification** — precise rules with conformance levels;
- a **protocol** — how agents read, use, and propose knowledge;
- a **documentary structure** — a normalized `.brain/` directory;
- a **knowledge model** — typed knowledge items with authority, provenance, and lifecycle;
- a **governance system** — who may promote knowledge to canonical, and how;
- a **context protocol** — how the right knowledge reaches the right task under a real context budget.

## What Project Brain is not

- ❌ a wiki
- ❌ a RAG pipeline or vector database
- ❌ a SaaS or hosted memory
- ❌ a database
- ❌ a proprietary agent memory
- ❌ a development framework

A reference implementation will exist, but **it does not define the standard**. The specification does.

## Design goals

| Goal | Meaning |
|---|---|
| **Repo-native** | The brain is files in the repository, nothing else. |
| **Versionable** | Plain text, diffable, mergeable, reviewable in a PR. |
| **Portable** | Works on any Git host, any OS, offline. |
| **LLM-independent** | No vendor-specific format; any agent can consume it. |
| **Human-first readable** | Markdown a human can read without tooling. |
| **Agent-exploitable** | Deterministic entry points, machine-readable metadata, explicit authority. |
| **Governable** | Generated knowledge never becomes truth without verification. |
| **Durable** | Designed to still make sense in ten years, whatever the agents look like. |

## The 30-second picture

A conformant project carries a `.brain/` directory:

```text
your-project/
├── AGENTS.md               # bridge file → points agents into the brain
├── .brain/
│   ├── brain.yaml          # Brain Manifest: entry point, spec version, structure
│   ├── overview.md         # what the project is and why it exists
│   ├── state/              # Current State: now, in-flight, frozen
│   ├── architecture/       # structure, boundaries, key flows
│   ├── decisions/          # Decision Records (why things are the way they are)
│   ├── rules/              # Business Rules and Invariants
│   ├── guides/             # how to work on this project
│   ├── knowledge/          # canonical domain knowledge
│   ├── candidates/         # proposed knowledge, not yet verified
│   ├── archive/            # historical knowledge, kept but no longer true
│   └── context/
│       ├── manifest.yaml   # Context Manifest: task → what to load
│       └── packs/          # Context Packs: curated reading lists per task type
└── src/ ...
```

Every knowledge item declares **who wrote it** (provenance), **how much to trust it** (authority), and **where it is in its life** (status). Agents read canonically, and **write only candidates** — humans promote.

## Repository map

| Path | Content |
|---|---|
| [`VISION.md`](VISION.md) | Why this standard exists, and the world it assumes. |
| [`PRINCIPLES.md`](PRINCIPLES.md) | The non-negotiable design principles. |
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | The four layers: Standard / Implementation / Project Content / Tools. |
| [`GLOSSARY.md`](GLOSSARY.md) | The full vocabulary of the standard. |
| [`spec/`](spec/) | The specification itself (v0.1 draft). **Normative.** |
| [`rfcs/`](rfcs/) | The change process: every substantial evolution starts as an RFC. |
| [`prior-art/`](prior-art/) | Honest comparison with AGENTS.md, ADR, C4, arc42, Diátaxis, and others. |
| [`examples/`](examples/) | Example brains (fictional projects only). |
| [`schemas/`](schemas/) | JSON Schemas for manifests and metadata (v0.2 target). |
| [`conformance/`](conformance/) | Conformance test suite (v0.3 target). |
| [`tools/`](tools/) | Pointers to reference tooling (v0.4 target). Tools never define the standard. |
| [`ROADMAP.md`](ROADMAP.md) | From v0.1 draft to v1.0 stable. |
| [`GOVERNANCE.md`](GOVERNANCE.md) | How the standard itself is governed. |
| [`CRITIQUE.md`](CRITIQUE.md) | Known limits and open problems of the current proposal. Read it. |

## Status and how to engage

The specification is at **v0.1 draft**. The fastest ways to help:

1. Read [`spec/v0.1/00-overview.md`](spec/v0.1/00-overview.md) and [`CRITIQUE.md`](CRITIQUE.md).
2. Try writing a `.brain/` for one of your own projects by hand.
3. Open an issue, or an [RFC](rfcs/) for substantial proposals.

## License

Specification and documentation: [CC BY 4.0](LICENSE.md). Future reference code: Apache-2.0.
