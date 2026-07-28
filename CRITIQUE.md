# Critique — limits of this proposal, and what the market says

Mission 8's own discipline applied to ourselves: before implementing anything, attack the proposal. This file is the standard's `needs-review` flag on itself. Sources for market claims: [`prior-art/`](prior-art/README.md).

## 1. The pertinence question, answered bluntly

**Is a new standard here pertinent at all?** The honest answer is: *yes, but in a narrower slot than the founding vision assumes, and only under strategic conditions.*

**Evidence for pertinence:**
- The exact combination this spec defines — authority + provenance + lifecycle + team-shared git-versioned memory + task-scoped loading — **exists nowhere**, and each piece is independently demanded: Cursor killed automatic Memories and told users to commit explicit rules; Cline's Memory Bank pattern spread by pure demand; the "context rot"/"junk drawer" critique is now standard vocabulary; academic surveys (RAD-AI, 2026) explicitly name the missing integration.
- The empirical core is validated: the ETH Zurich study (Feb 2026) found **human-curated** context helps (+4%) while **generated, uncurated** context hurts, and all always-on context costs +14–22% tokens. That is, almost line for line, this spec's thesis: curation (verification), non-redundancy (record what code cannot say), selective loading (packs).

**Evidence against:**
- The niche is **squeezed from three directions**: AGENTS.md (Linux Foundation, 60K+ repos) owns the entry point; vendor memory features (Claude auto-memory, Skills' progressive disclosure, Cursor scoped rules) are absorbing the learning loop and selective loading; spec-driven tools (Spec Kit 93K stars, Kiro GA) are absorbing structured repo-native knowledge. Each incumbent is one feature announcement away from closing part of our gap.
- The genre's graveyard is unambiguous: **llms.txt** (massively deployed, ~97% never read by any crawler, no provider commitment) and **ai-context-standard** (dead in weeks) both died the same death — *a format without a committed consumer*. Nothing about our spec's quality immunizes us against this, and it is the single most likely way this project fails.

**Verdict:** the standard is pertinent as **the governed knowledge layer underneath the existing ecosystem** — compiling into AGENTS.md, embedding ADRs, coexisting with SDD — not as a rival entry point. The founding vision's instinct ("define the protocol first, like OpenAPI") is right about rigor but wrong about sequencing if read as "spec now, tools much later": OpenAPI had Swagger tooling *before* the spec generalized. See §2.

## 2. Strategic limits (the ones that can kill the project)

### L1 — No committed consumer at launch *(severity: existential)*
Our roadmap defers the reference CLI to v0.4 and native agent consumption to ~v1.0. The market record says that is exactly backwards: every dead standard in this genre died spec-first; the one runaway repo-native success (planning-with-files, 25.8K stars in 7 months) shipped as a **drop-in skill for existing agents** with zero adoption ceremony.
**Amendment proposed:** invert the roadmap's center of gravity. From v0.1, ship alongside the spec: (a) a bridge-file generator + minimal loader packaged as skills/rules for today's major agents, so brains are *consumed* on day one; (b) the validator early (v0.2, not v0.3). The spec still rules (P10); but the spec must never be alone.

### L2 — Unproven benefit *(severity: high)*
We assert brains make agents better; ETH-style evidence could be produced *against* us (their generated-context finding). If a Level 2 brain doesn't measurably beat a good AGENTS.md on task success and token cost, the standard has no reason to exist.
**Amendment proposed:** add to v0.2–0.3 a **published benchmark**: same tasks, same agent, {no context | AGENTS.md | brain+packs}. Accept the risk of a negative result; a standard that fears measurement deserves to die.

### L3 — The maintenance economics are still unproven *(severity: high)*
The rot literature says only proximity+ownership+review-coupling+mechanical freshness keep docs alive. We specify all four — but specifying is not causing. ADR theatre happened *inside* repos, with immutable statused records. Our real bet is that **agents change the economics**: they read on every task (making errors in the brain immediately costly and visible) and they draft candidates (making writing nearly free). This bet is plausible and undemonstrated.
**Mitigation:** the dogfood requirement (this repo's own brain, v0.1 exit) plus adopter case studies (v0.5) are the test. If maintaining a brain takes >30 min/week for an active project, the model fails P12 and must be simplified.

### L4 — Verification is a human bottleneck by design *(severity: medium, accepted)*
P4 makes humans the promotion gate; a busy team's `candidates/` will silt up, and teams may respond by rubber-stamping (authority inflation) or ignoring (knowledge loss). We accept the bottleneck — it *is* the trust model — but v0.1 gives no relief valves beyond candidate expiry.
**Open problem (RFC welcome):** graduated verification (e.g. a reviewed merge of a candidate PR counting as verification), sampling review, or team-level verification policies in the manifest.

## 3. Technical limits of the current draft

### T1 — Conflict precedence is naive
5.2 resolves conflicts by (authority, type-class, recency). Recency is a weak oracle: an old verified invariant vs. a fresh verified state note about a temporary freeze — precedence picks wrongly in some real cases. A `priority` override was rejected (invites inflation) but the problem stands. *RFC material.*

### T2 — IDs have no uniqueness enforcement
`id` uniqueness is asserted, not guaranteed; two branches can mint the same id and merge cleanly. Only tooling (validator in CI) can catch this — one more reason for L1's amendment.

### T3 — `on_demand` matching underspecified
Glob semantics (`**` behavior, case, relative-to-what) are named but not pinned; two implementers could diverge. Must be nailed to a specific glob dialect in v0.2 schemas.

### T4 — The nine types may be two too many
Diátaxis won with four quadrants. Distinctions like `knowledge` vs `architecture` vs `guide` will blur in practice; `note` is an escape hatch that will be overused. Watch field data; collapsing types is a breaking change, so decide before 1.0.

### T5 — Monorepo/umbrella semantics are thin
"Nearest root governs" ignores cross-cutting conflicts (umbrella invariant vs child rule). Needs a real precedence story before Level 3 claims in monorepos are meaningful.

### T6 — No content-integrity story
`verified` blocks are plain text; anyone can edit them, and Git history is the only audit trail. Fine for trust-your-repo teams; insufficient for regulated environments. Deliberately deferred (signed-verification profile, post-1.0) — but the spec should say *explicitly* what threat model verification does and does not address. *(Spec bug: 6.2 hints at this; make it a proper subsection.)*

### T7 — Freshness dates rely on clocks and discipline
`review_by` sweeps need something that runs (CI, bot). Without it, Level 3's freshness guarantees are decorative. Again feeds L1: the freshness bot belongs in the early tooling, not v0.4+.

### T8 — Language and duplication
One `language` per brain is declared, but nothing addresses bilingual teams or the duplication risk with in-repo docs (`docs/`, package READMEs). Guidance in 3.6/4.4 ("link, don't restate") is advice, not mechanism; drift between brain and docs is unmodeled.

## 4. What we are explicitly betting on

Made falsifiable so future us can check:

1. **Agents make governed knowledge economically viable** (reading on every task creates the missing read-path; drafting candidates removes the write-cost). *Falsified if* adopters' brains rot like wikis despite tooling.
2. **Authority/provenance/lifecycle is the missing layer**, not over-engineering. *Falsified if* teams thrive on flat AGENTS.md + Spec Kit and never hit the trust problem.
3. **A vendor-neutral spec can outrun vendor features.** *Falsified if* two majors ship team-shared repo memory natively before we have adopters (the 6–18 month window).
4. **Semantics outlive tools** (P11) — the ten-year bet, unfalsifiable until it isn't.

## 5. Summary of proposed amendments

| # | Change | Where |
|---|---|---|
| A1 | Invert roadmap: minimal loader + bridge generator + validator ship with v0.1–0.2; CLI is not "v0.4 someday" | `ROADMAP.md` |
| A2 | Published benchmark vs no-context and AGENTS.md baselines | roadmap v0.2–0.3 |
| A3 | Distribution as drop-in skills for existing agents, not adoption ceremony | roadmap v0.5 → v0.2 |
| A4 | Pin glob dialect; add id-uniqueness check to validator duties | spec 8.2/9.1, v0.2 |
| A5 | Threat-model subsection for verification | spec 06 |
| A6 | Graduated-verification RFC invited | rfcs/ |
| A7 | Monorepo precedence RFC invited | rfcs/ |
| A8 | Re-examine type count against field data before 1.0 | spec 04 |

These amendments are deliberately *not* yet applied to the spec: they are the first agenda of the RFC process, so the standard's own governance gets exercised on its own founding critique.
