# Vision

## The world we are in

Software teams have accepted, for decades, that a project's most valuable knowledge is its most volatile:

- Code tells you **what** the system does today. It never tells you **why**.
- Documentation, when it exists, describes an idealized system that stopped existing two quarters ago.
- Decisions are made in meetings, pull requests, and chat threads — media with a half-life of weeks.
- The real constraints ("never change this table without talking to billing", "the retry logic is load-bearing, an incident taught us why") live in people.

This was survivable when the only readers of a codebase were long-tenured humans who could carry context in their heads and transmit it orally.

Two things broke that equilibrium:

1. **Team velocity** — people change projects and companies faster than knowledge can be orally transmitted.
2. **AI agents** — a new class of contributor that arrives with *zero* context, at *every* session, and works at a speed where missing context turns instantly into wrong code.

Agents today compensate with heuristics: scan the tree, read the README, grep, guess. Every vendor is building a proprietary answer — session memories, hosted context stores, per-tool config files. Each answer locks the project's knowledge into one tool, one vendor, one format.

**Project knowledge is becoming the most valuable artifact in software — and it has no standard home.**

## The world we want

We want `git clone` to be enough.

A repository should be **autonomous**: it should carry, alongside its code, everything a competent stranger — human or machine — needs in order to work on it correctly. Not a snapshot of documentation, but a **living, governed knowledge structure**:

- **why** the project exists, and what it refuses to be;
- **how** it is shaped, and where its boundaries are;
- **what** was decided, when, and why;
- **which rules** must never be broken, and which are merely habits;
- **where** the project stands right now — what is in flight, what is frozen;
- **how** to contribute without stepping on landmines.

And this structure must be:

- **owned by the project** — it lives in the repo, is versioned by Git, is reviewed like code;
- **vendor-neutral** — no agent, model, or platform has privileged access;
- **governed** — machine-generated text can *propose* knowledge, but only verification makes it *true*;
- **durable** — plain files, explicit semantics, no runtime dependency.

## Why a standard, and not a product

OpenAPI did not win because it was the best HTTP documentation tool. It won because it was a **contract** that any tool could produce and any tool could consume. The value was in the agreement, not the software.

Project knowledge needs the same move. If every agent vendor ships its own memory format, projects will fragment their knowledge across tools and lose it at every migration. A standard inverts the power relationship: **the project owns its brain; tools merely visit it.**

This is why Project Brain is specified before it is implemented. The specification is the product. Reference tools exist to prove the spec, not to replace it.

## What success looks like

- **Year 1** — A stable v1.0 specification. A handful of real projects maintain a `.brain/` by hand and report that new contributors (human and agent) onboard measurably faster.
- **Year 3** — Major coding agents natively detect `brain.yaml` and load Context Packs instead of guessing. Linting a brain is as normal as linting code. "Does this PR update the brain?" is a routine review question.
- **Year 10** — The agents of 2036 look nothing like today's. The `.brain/` directories written in 2026 are still readable, still meaningful, still loading — because they are text, in a repo, with explicit semantics. That is the whole bet: **semantics outlive tools.**

## What we refuse

- We refuse to host anyone's knowledge. There is no Project Brain cloud.
- We refuse vendor privileges. No agent gets a proprietary field.
- We refuse magic. No embedding, ranking, or retrieval behavior is part of the standard — those are implementation choices that will age; the knowledge model must not age with them.
- We refuse to replace judgment. The standard governs *how* knowledge is recorded and trusted, never *what* a team should decide.
