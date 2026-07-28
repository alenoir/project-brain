# 02 — Terminology

Normative definitions. Where the informative [`GLOSSARY.md`](../../GLOSSARY.md) and this chapter differ, this chapter prevails.

**Brain.** The complete knowledge structure of one project: a Brain Root containing a Brain Manifest and a set of Knowledge Items, optionally with Context material. A Brain conforms to exactly one version of this specification, declared in its manifest.

**Brain Root.** The directory containing the Brain Manifest. RECOMMENDED location: `.brain/` at the repository root. A repository MAY contain multiple Brain Roots (e.g. a monorepo with one Brain per package); each is independent.

**Brain Manifest.** The file `brain.yaml` directly inside the Brain Root. Its presence is what constitutes a Brain. Fields: chapter 09.

**Bridge File.** A non-normative file outside the Brain Root (e.g. `AGENTS.md`, `CLAUDE.md`) whose purpose is to direct tools without native Brain support to the Brain Root. Bridge Files MUST NOT contain knowledge that is not in the Brain.

**Knowledge Item.** One Markdown file within the Brain Root consisting of a Metadata Block (YAML front matter) followed by Markdown content. The atomic unit of knowledge, identity, authority, provenance, and lifecycle.

**Metadata Block.** The YAML front matter of a Knowledge Item, delimited by `---` lines, containing the fields defined in chapter 09.

**Knowledge Type.** The declared kind of a Knowledge Item (`overview`, `state`, `architecture`, `decision`, `rule`, `invariant`, `guide`, `knowledge`, `note`), constraining its expected content and its precedence class. Chapter 04.

**Authority.** The declared trust level of a Knowledge Item: one of `canonical`, `informative`, `candidate`, `deprecated`, `archived`. Chapter 05.

**Canonical Knowledge.** The set of Knowledge Items with authority `canonical`.

**Knowledge Candidate (Candidate).** A Knowledge Item with authority `candidate`: proposed, binding no one, awaiting Verification or rejection.

**Provenance.** The declared origin of a Knowledge Item: one of `human`, `agent`, `mixed`, `imported`. Chapter 06.

**Generated Knowledge.** Any Knowledge Item whose provenance is `agent` or `mixed`.

**Verification.** The recorded human act that attests a Knowledge Item is true and may carry authority `canonical`, expressed through the `verified` metadata fields and Git history. Chapter 06.

**Source.** A reference recorded in an item's `sources` field: a repository path, commit, pull request, issue, URL, or free-form citation supporting the item's claims.

**Current State.** The Knowledge Item(s) of type `state` describing the present situation of the project.

**Decision Record.** A Knowledge Item of type `decision` recording one significant choice: its context, the options considered, the outcome, and its consequences.

**Business Rule.** A Knowledge Item of type `rule` stating a domain-level requirement the software must honor.

**Invariant.** A Knowledge Item of type `invariant` stating a constraint that must never be violated. Invariants have the highest conflict precedence (chapter 05).

**Historical Knowledge.** Knowledge Items with authority `archived`, preserved in the Archive.

**Archive.** The area of the Brain (`archive/`) holding Historical Knowledge.

**Lifecycle.** The permitted sequence of an item's `status` values and the rules governing transitions. Chapter 07.

**Drift.** A recognized divergence between a Knowledge Item and reality. Drift is handled by flagging (`status: needs-review`), amendment, deprecation, or archival — never by silent deletion. Chapter 07.

**Context.** The subset of a Brain selected for a given task.

**Context Manifest.** The file `context/manifest.yaml` inside the Brain Root, mapping Intents to Context Packs and naming the default pack. Chapter 08.

**Context Pack.** A named, ordered selection of Knowledge Items (required and optional) curated for one Intent. Chapter 08.

**Intent.** A named category of task with which a reader approaches the Brain.

**Context Budget.** The finite reading capacity (attention, tokens, time) under which Context is assembled. The specification treats it as a design constraint, not a measured quantity.

**Reader / Writer / Validator.** Tool conformance roles, defined in chapter 01.

**Conformance Level.** The degree of adoption a Brain claims: 1 (Minimal), 2 (Structured), 3 (Governed). Chapter 01.
