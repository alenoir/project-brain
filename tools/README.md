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

## Staying up to date

Installed repositories are deliberately decoupled from this one: a brain is self-contained files, pins its spec version in `brain.yaml`, and never phones home — nothing here can break your projects (Principles P1, P2, and the durability contract of [spec ch. 10](../spec/v0.1/10-versioning.md)). Updates are therefore always **pull, never push**:

- **Tools** (the copied skills/rules): refresh them anytime with
  `curl -fsSL https://raw.githubusercontent.com/alenoir/project-brain/main/install.sh | sh -s -- --update`
  — tool-owned files are overwritten, your `.brain/` content and `AGENTS.md` never are.
- **Automatically**: install the weekly [GitHub Action](github-actions/update-project-brain-tools.yml) (`install.sh --auto-update`, or copy it to `.github/workflows/`). It runs `--update` every Monday and **opens a pull request** when the tools changed — never a silent commit: reviewing that PR is the same governance gesture as everywhere else in the standard. Requires "Allow GitHub Actions to create and approve pull requests" in the repo's Actions settings.
- **The spec**: your brain keeps working against the version it pins. Migrating to a newer spec version is an explicit, human-approved act, guided by the migration notes each version ships (post-1.0, minors are strictly additive — nothing to do at all).
- **Knowing about it**: watch this repository's releases. Significant changes land as spec versions and release notes, never as silent edits.

## Validate in CI

Copy [`github-actions/validate-brain.yml`](github-actions/validate-brain.yml) to your repo's `.github/workflows/`: every PR touching `.brain/` is checked against the spec by [`conformance/validate.py`](../conformance/validate.py) — non-conformant knowledge (canonical without verification, candidates claiming authority, broken packs…) fails the check instead of silently rotting. Locally or on demand, say **"validate the brain"** to your agent.

## Planned (v0.4, separate repository)

Reference CLI: `brain init`, `brain validate`, `brain pack <intent>`, `brain triage`, `brain gc` — see [`ROADMAP.md`](../ROADMAP.md).
