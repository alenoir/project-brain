# Tools — reference consumers

This directory holds the standard's first **reference consumers**: prompt-level artifacts (no code) that make today's agents follow the Brain protocol. They exist because a standard without a committed consumer is a dead letter (see `CRITIQUE.md` L1 and RFC 0001).

**Layering note.** `ARCHITECTURE.md` places tools in Layer 2, outside this repository. These artifacts are the deliberate, bounded exception: they contain no code — only Markdown instructions that restate the spec's protocols for specific agents — and they will move to a dedicated Layer 2 repository when the reference CLI does (v0.4). Where any of them disagrees with the spec, the spec wins (Principle P10).

## Install on your repository

One command, from inside the target repo:

```sh
curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh
```

then open your coding agent and say **"init the brain"** — the `brain-init` skill analyzes the code, git history, and existing docs, and generates the brain content itself, everything marked `candidate` for you to verify and promote.

What the installer places (idempotent, never overwrites):

| Artifact | Role | Location in your repo |
|---|---|---|
| Level 1 scaffold | manifest + templates | `.brain/` |
| Bridge File | discovery by every AGENTS.md-aware agent | `AGENTS.md` (created or appended) |
| [`skills/claude-code/SKILL.md`](skills/claude-code/SKILL.md) | protocol compliance: packs, authority, candidates-only writing | `.claude/skills/project-brain/SKILL.md` |
| [`skills/claude-code-init/SKILL.md`](skills/claude-code-init/SKILL.md) | agent-driven bootstrap ("init the brain") | `.claude/skills/brain-init/SKILL.md` |
| [`rules/cursor/project-brain.mdc`](rules/cursor/project-brain.mdc) | same protocol for Cursor (only if `.cursor/` exists) | `.cursor/rules/project-brain.mdc` |

The Bridge File is the floor (discovery); the skill/rule is what makes the protocol *followed*.

## Planned (v0.4, separate repository)

Reference CLI: `brain init`, `brain validate`, `brain pack <intent>`, `brain triage`, `brain gc` — see [`ROADMAP.md`](../ROADMAP.md).
