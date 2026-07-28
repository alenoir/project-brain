# Prior art — what exists, what it teaches, what remains open

Honest positioning of Project Brain against the systems that already occupy parts of this territory. Researched July 2026; sources linked. If this analysis is outdated or unfair, correcting it is a first-class contribution.

The one-line conclusion first: **the pieces of Project Brain all exist somewhere; nobody has assembled them, and the assembly is the standard.** But the niche is squeezed from three sides (instruction files, vendor memories, spec-driven tools), and the graveyard of consumed-by-nobody standards is real. See [`CRITIQUE.md`](../CRITIQUE.md) for what this implies.

---

## 1. Agent instruction files

### AGENTS.md

A plain-Markdown "README for agents" at repo root. Originated by OpenAI (Codex); contributed in **December 2025 to the Agentic AI Foundation** (Linux Foundation, with Anthropic, Google, Microsoft, AWS, Block among founders). Claimed adoption: **60,000+ open-source repos**, native support in ~28+ tools (Codex, Cursor, Copilot coding agent, Gemini CLI, Aider, Zed, Devin, …). ([agents.md](https://agents.md/), [Linux Foundation announcement](https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation))

**What it got right** — zero friction (any Markdown, no required fields), vendor neutrality, and above all **a guaranteed read-path**: agents load it on every task, which is why these files stay maintained while wikis rot.

**What it structurally lacks** — it is a *prompt*, not a knowledge model: no schema, no scoping ("load only for X"), no authority levels, no provenance, no lifecycle, no distinction between a load-bearing invariant and a stale note. Everything loads always ([Augment: "your agent's context is a junk drawer"](https://www.augmentcode.com/blog/your-agents-context-is-a-junk-drawer)). Empirically, an [ETH Zurich study (Feb 2026)](https://arxiv.org/pdf/2602.11988) found **LLM-generated context files slightly *reduce* agent success** while human-curated ones help (+4%), and either way cost +14–22% reasoning tokens — evidence that *curation and selective loading*, not the file's existence, are what matter.

**Relationship to Project Brain: complement, not competitor.** AGENTS.md won the entry-point namespace; fighting it would be suicide and is unnecessary. In this standard, AGENTS.md is the **Bridge File** (spec 3.4): the universally-read pointer into the brain. A brain should be able to *generate* a good AGENTS.md. What AGENTS.md cannot hold — authority, provenance, lifecycle, packs — is exactly what the brain adds underneath it.

### Vendor rule files (CLAUDE.md, .cursor/rules, copilot-instructions.md, GEMINI.md, …)

Still fragmented: a polyglot team ships 3–5 near-duplicate files; converters and symlink guides are a cottage industry. Convergence is real but only at the bottom (AGENTS.md as lowest common denominator); vendors keep proprietary layers on top — notably **Cursor's `.mdc` rules with glob scoping and `alwaysApply`**, the closest existing thing to per-task context selection. ([config-file landscape](https://www.deployhq.com/blog/ai-coding-config-files-guide))

**Lesson reused** — glob-scoped activation works and users want it: it inspired the `on_demand` mechanism of Context Packs (spec 8.2) and the `scope` metadata field, but vendor-neutrally.

### llms.txt — the cautionary tale

Website-level LLM index file (Answer.AI, 2024). By 2026: ~10% deployment on large domains, **but ~97% of the files receive zero AI-crawler requests and no major provider parses it in production** ([PPC Land](https://ppc.land/llms-txt-adoption-rises-8-8x-but-97-of-files-get-zero-ai-requests/), [state of llms.txt 2026](https://ai.aeo.press/the-state-of-llms-txt-in-2026)).

**Lesson** — the defining risk of this whole genre: **a format standard without a committed consumer is a dead letter.** Deployment ≠ consumption. This lesson reshapes our roadmap (see CRITIQUE §2).

---

## 2. Knowledge & decision frameworks

### ADR (Architecture Decision Records)

Per-decision, repo-native records (Nygard 2011; [adr.github.io](https://adr.github.io/); MADR; log4brains). ThoughtWorks Radar "Adopt" since 2017; cited in Azure and AWS guidance. **The single most proven ancestor of this standard**: one-decision-one-file, immutability, status lifecycle with `superseded-by` — we adopt all of it (spec 4.3, 7.3), generalized beyond architecture.

Its documented failure mode is equally instructive: **ADR theatre** — records written after the fact, read by nobody, because nothing in the workflow ever routes a reader *to* an ADR ([why ADRs die](https://www.javacodegeeks.com/2026/05/the-reason-most-architecture-decision-records-get-written-and-never-read-is-architectural-not-cultural.html)). ADRs solved the write-path and never built a read-path. Context Packs exist precisely to be that read-path: `decisions/` content gets *loaded* when relevant, not merely stored.

**Migration is first-class**: existing ADR logs import 1:1 into `decisions/` (roadmap v0.5).

### arc42

A 12-section architecture documentation template (Starke/Hruschka), strong in European industry. Proves the value of **fixed slots** — predictable places for constraints, quality goals, risks, glossary — and also marks **the ceiling of tolerable complexity** (12 sections needed a certification industry to push them; our type system stays at nine, and Level 1 at two files). arc42 is a *container without an engine*: no ownership, freshness, or staleness detection — the machinery we add via metadata (7.5). Recent research ([RAD-AI](https://arxiv.org/pdf/2603.28735)) explicitly notes that no holistic framework yet integrates agent guidance with arc42/C4-style documentation — the gap this standard targets is acknowledged in the literature.

### C4 model

Four fixed zoom levels for architecture diagrams (Brown; Structurizr for diagrams-as-code). Two lessons reused: the **zoom-level principle** (a reader requests the altitude a task needs — the diagram-world analogue of Context Packs), and the honesty of the community **abandoning the Code level** as unmaintainable — don't standardize granularity nobody will keep true (our granularity guidance, 4.4). C4 itself covers structure only — no rationale, state, rules, or lifecycle — and composes cleanly with a brain (`architecture/` can embed C4).

### Diátaxis

Four-quadrant typology for *user-facing product docs* (tutorials/how-to/reference/explanation); the strongest adoption story in documentation (Django, Canonical, Cloudflare). It deliberately does not cover project memory — decisions, provenance, internal state — and has no governance model. **Lesson reused**: what spreads is a **simple, memorable typology with a no-mixing rule** — this shaped our closed list of nine knowledge types and the one-item-one-knowledge rule (4.1). Diátaxis governs a project's docs *for users*; the brain governs its knowledge *for contributors* — orthogonal, compatible.

### Docs-as-Code & the rot literature

Docs in the repo, reviewed in PRs (Backstage TechDocs at Spotify: 5,000+ doc sites). The empirical base on staleness is damning and consistent: **~78% of developers report struggling with outdated docs; architecture docs rot fastest; decay is silent** ([Fraunhofer IESE survey](https://www.iese.fraunhofer.de/content/dam/iese/dokumente/alte-dateien/study_software_architecture_documentation_for_developers_survey-en-fraunhofer_iese.pdf)). The only interventions with demonstrated effect ([Google SWE book, ch. 10](https://abseil.io/resources/swe-book/html/ch10.html)): **proximity to code, named ownership, review-coupling, mechanical freshness dates with automated nagging**. All four are absorbed into the standard: the brain lives with the code, `verified.by` names an owner, changes ride code PRs, and `review_by`/`expires` make staleness machine-detectable (7.5).

### RFC processes (IETF, Rust, PEPs)

The governance ancestor: numbered immutable proposals, lifecycle states, recorded rejections, **"running code" before standardization**, and — critically — **proportionality** (most changes skip the heavy process). Adopted wholesale for the standard's own evolution (`rfcs/`, spec 10.3) and echoed inside brains (cheap candidates vs. governed canonical).

---

## 3. Memory systems & repo-native attempts

### Vendor memories (Claude Code auto-memory, Cursor Memories)

Claude Code's auto-memory (2026) learns from sessions — into a **machine-local** directory outside the repo: not versioned, not reviewed, not team-shared. Cursor launched Memories in 2025 and **removed them in late 2025**, telling users to export memories into committed Rules ([forum](https://forum.cursor.com/t/memories-not-showing/143820)) — a vendor retreating from automatic memory back to explicit repo files. **No major vendor ships team-shared, git-versioned learned memory.** That absence is the clearest structural gap this standard fills, and Cursor's retreat is evidence the market is discovering it wants exactly this: explicit, committed, reviewable knowledge.

### External memory layers (mem0, Letta/MemGPT, Zep)

Sophisticated external stores (vector/graph/temporal). All violate this standard's first principle by construction: the memory lives in a service, not with the project. They solve a different problem (conversational/user memory at runtime) and can coexist with a brain — but they are what P1 exists to not depend on.

### Basic Memory (basicmachines-co)

MCP server persisting a knowledge graph as **local plain Markdown** — the closest memory *product* to file-native, and validation that Markdown-as-knowledge-store works. But its default home is a personal notes directory: personal-scope, not project-scope; no authority/verification model. Reused idea: entity-linked Markdown knowledge; rejected: personal-by-default scope.

### Cline Memory Bank

The most-adopted repo-native memory *pattern* (copied by Roo Code, Kilo): a `memory-bank/` of structured Markdown the agent re-reads each session. Proves demand for exactly this shape — and, being a pure prompt convention with no schema, lifecycle, or authority, exhibits the junk-drawer rot the trust model exists to prevent. A Memory Bank is roughly "a Level 1 brain without governance"; migration is natural.

### brain.md (mindmuxai)

Created June 2026; the most conceptually ambitious neighbor: `BRAIN.md` + `brain/` directory, pages with rewritable "compiled truth" over an **append-only evidence timeline**, single-writer CLI, tamper-evident updates. Genuinely takes provenance seriously — the only project found that does. Differences: tool-first rather than spec-first (the CLI *is* the product), no selective-loading/context-pack mechanism, no conformance model, single-writer where we rely on Git's native multi-writer review flow. Early traction (~235 stars) says the idea is unproven but also unclaimed.

### ai-context-standard (vibe-stack)

Proposed a hierarchical context standard (Aug 2025); **dead within weeks (18 stars)**. Cause of death, per the llms.txt pattern: a spec with no committed consumer and no tooling. Its epitaph is the most important design input in this repository (CRITIQUE §2).

### projectmem (riponcm)

Local-first MCP memory capturing issues/attempts/decisions across tools (May 2026, ~200 stars). Stores **locally, not in the repo** — a personal experience layer. Its capture taxonomy (attempts, gotchas) is a good candidate-generation vocabulary; its storage model is the opposite of ours.

### Spec-driven development (GitHub Spec Kit, Amazon Kiro, OpenSpec)

The heavyweight convergent evolution. Spec Kit (93K+ stars) generates a `constitution.md` into a directory literally named **`.specify/memory/`**; Kiro 1.0 (AWS, GA July 2026) ships repo-native **steering files** (`product.md`, `tech.md`, `structure.md`) plus per-feature specs. Both have independently reinvented "durable project knowledge in git" — *forward-looking only*: what to build next, nothing about accumulated experience, decisions' provenance, or knowledge lifecycle. A brain complements SDD: steering/constitution content maps onto `overview`/`rules`/`guides`; specs' outcomes should *land* in `decisions/` and `state/`. The collision of these tools with AGENTS.md (their own communities debate the overlap) shows the territory is unsettled precisely where this standard operates.

### planning-with-files (OthmanAdi)

Manus-style persistent markdown planning, **25.8K stars in ~7 months** — the one runaway repo-native success. It won not as a standard but as a **drop-in skill for 60+ existing agents**. Lesson absorbed into strategy, not spec: distribution beats schema quality; meet agents where they are (CRITIQUE §2).

---

## 4. Synthesis

### What Project Brain legitimately reuses

| From | Reused |
|---|---|
| ADR | one-decision-one-file, immutability, supersession lifecycle |
| RFC/PEP | numbered immutable records, recorded rejections, proportional process |
| Google/docs-as-code | ownership, freshness dates, review-coupling, proximity |
| Diátaxis | small memorable typology, no-mixing rule |
| C4 | zoom levels → task-scoped loading; abandon unmaintainable granularity |
| arc42 | fixed slots for neglected knowledge (constraints, risks, glossary) |
| Cursor rules | glob-scoped activation → `on_demand`, `scope` |
| AGENTS.md | the read-path insight; the Bridge File role |
| brain.md | evidence that provenance-first design is viable |
| Cline Memory Bank | demand proof for repo-native session memory |

### What none of them provide — the actual novelty

1. **Authority as a first-class, machine-readable property** — no existing format distinguishes a load-bearing invariant from a stale note, with defined conflict precedence.
2. **Provenance + verification as governance** — "agents propose, humans promote" exists nowhere as a specified, auditable flow (brain.md comes closest, tool-first).
3. **Knowledge lifecycle with mechanical staleness** — statuses, `review_by`, drift protocol; rot made visible instead of silent.
4. **Context Packs** — task-scoped, ordered, budget-aware loading as a *vendor-neutral spec* (Cursor has it proprietary; AGENTS.md loads everything always; the ETH token-cost findings make this a measurable win).
5. **Team-shared, git-versioned agent memory** — the structural gap every vendor has left open.
6. **The assembly itself, as a leveled, conformance-tested standard** rather than a tool's convention.

### What the market says back

Three warnings, developed in [`CRITIQUE.md`](../CRITIQUE.md): the niche is being **squeezed from three directions** (AGENTS.md absorbing instruction use-cases, vendor memories absorbing the learning loop, SDD absorbing structured knowledge); **standards without committed consumers die** (llms.txt, ai-context-standard); and the empirical evidence (ETH) cuts both ways — it justifies curation+selective loading and proves mere context files aren't automatically useful. The window is real and roughly 6–18 months wide.
