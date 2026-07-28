# Tools — reference consumers

This directory holds the standard's first **reference consumers**: prompt-level artifacts (no code) that make today's agents follow the Brain protocol. They exist because a standard without a committed consumer is a dead letter (see `CRITIQUE.md` L1 and RFC 0001).

**Layering note.** `ARCHITECTURE.md` places tools in Layer 2, outside this repository. These artifacts are the deliberate, bounded exception: they contain no code — only Markdown instructions that restate the spec's protocols for specific agents — and they will move to a dedicated Layer 2 repository when the reference CLI does (v0.4). Where any of them disagrees with the spec, the spec wins (Principle P10).

## Install on your repository

| Agent | Copy | To |
|---|---|---|
| Claude Code | [`skills/claude-code/SKILL.md`](skills/claude-code/SKILL.md) | `your-repo/.claude/skills/project-brain/SKILL.md` |
| Cursor | [`rules/cursor/project-brain.mdc`](rules/cursor/project-brain.mdc) | `your-repo/.cursor/rules/project-brain.mdc` |
| Any AGENTS.md-aware agent (Codex, Copilot, Gemini CLI, Aider, …) | the Bridge File snippet from [spec 3.4](../spec/v0.1/03-brain-structure.md) | `your-repo/AGENTS.md` |

The Bridge File is the floor (discovery); the skill/rule is what makes the protocol *followed*: pack selection, authority semantics, candidates-only writing.

## Planned (v0.4, separate repository)

Reference CLI: `brain init`, `brain validate`, `brain pack <intent>`, `brain triage`, `brain gc` — see [`ROADMAP.md`](../ROADMAP.md).
