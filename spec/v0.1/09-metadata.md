# 09 — Metadata Reference

Exact field definitions. JSON Schemas will formalize this chapter in standard v0.2; until then, this prose is the reference.

## 9.1 Knowledge Item — Metadata Block

YAML front matter, first thing in the file, `---` delimited.

### Required (Level 2+)

| Field | Type | Rules |
|---|---|---|
| `id` | string | Unique in the Brain. RECOMMENDED `type.slug` (`[a-z0-9-]+`, dot-separated). Immutable across moves. |
| `type` | enum | One of the nine types (chapter 04). |
| `title` | string | Human-readable, one line. |
| `status` | enum | `draft` \| `active` \| `needs-review` \| `deprecated` \| `archived` (chapter 07). |
| `authority` | enum | `canonical` \| `informative` \| `candidate` \| `deprecated` \| `archived` (chapter 05). |
| `provenance` | enum | `human` \| `agent` \| `mixed` \| `imported` (chapter 06). |
| `created` | date (ISO 8601) | Date of first authorship. |
| `updated` | date (ISO 8601) | Date of last substantive edit. Drives recency precedence (5.2). |

### Conditional

| Field | Type | Required when | Rules |
|---|---|---|---|
| `verified` | object | `authority: canonical` | `by` (string, human/role identity — never a tool), `at` (date), `note` (optional string). See 6.2. |
| `superseded_by` | string (id) | `status: deprecated` and a replacement exists | Points to the replacing item's `id`. |
| `review_by` | date | `type: state` | Past this date ⇒ treat as `needs-review` (7.5). |

### Optional

| Field | Type | Meaning |
|---|---|---|
| `sources` | list | Evidence references. Each entry one of: `{path: <repo path>}`, `{commit: <sha>}`, `{pr: <number>}`, `{issue: <number>}`, `{url: <url>}`, `{ref: <free text>}`. |
| `tags` | list of strings | Free-form facets. No semantics in the standard. |
| `supersedes` | string (id) | Inverse pointer of `superseded_by`. |
| `expires` | date | Item is void after this date (7.5). |
| `review_every` | duration (`90d`, `6m`, `1y`) | Declared review cadence. |
| `review_note` | string | Why this item is `needs-review` (7.4). |
| `deprecation_note` | string | Why this item was deprecated. |
| `generator` | string | Free-form producing-tool label, audit only (6.1). No semantics. |
| `authors` | list of strings | Human and/or agent identities that contributed. |
| `relates_to` | list of ids | Non-directional cross-references. |
| `scope` | list of repo paths/globs | The code surface this item governs (enables `on_demand` matching and drift tooling). |

### Extension fields

Unrecognized fields **MUST** be ignored by Readers (never an error). Projects and tools **SHOULD** namespace their extensions with `x-` (`x-jira: PROJ-142`). Extension fields **MUST NOT** alter standard semantics (an `x-` field cannot grant authority).

## 9.2 Brain Manifest (`brain.yaml`)

| Field | Req. | Type | Meaning |
|---|---|---|---|
| `brain` | ✔ | int | Manifest format marker. `1` for this spec generation. |
| `spec` | ✔ | string | Spec version this Brain targets (`"0.1"`). |
| `conformance` | ✔ | int | Claimed level: `1` \| `2` \| `3` (chapter 01). |
| `entry` | ✔ | path | First item every reader reads. Normally `overview.md`. |
| `name` |  | string | Project name. |
| `description` |  | string | One-line project description. |
| `context` |  | path | Path to the Context Manifest. Default `context/manifest.yaml`. |
| `verification` |  | enum | `explicit` (default) \| `merge` — how canonical promotion is signed (spec 6.4, RFC 0002). `merge` is RECOMMENDED for solo maintainers and small teams. |
| `areas` |  | map | Overrides of the standard area paths, if the project deviates (e.g. `decisions: adr/`). Standard names, custom paths. |
| `children` |  | list of `{path}` | Child Brain Roots (monorepo umbrella, 3.5). |
| `language` |  | BCP 47 tag | Primary natural language of the Brain's content (`en`, `fr`, …). |
| `x-*` |  | any | Namespaced extensions. |

## 9.3 Context Manifest and Packs

Defined by example in chapter 08; field summary:

**`context/manifest.yaml`** — `context` (int, format marker, ✔), `default` (pack name, ✔), `packs` (map: name → `{file, description}`, ✔).

**Pack file** — `pack` (int, format marker, ✔), `intent` (string, ✔), `description` (string), `required` (ordered list of path/id/directory entries, ✔ may be empty), `recommended` (ordered list), `on_demand` (list of `{match: <glob>, load: [entries]}`).

## 9.4 Dates, identities, durations

- All dates: ISO 8601 (`2026-07-28`). Times are unnecessary; days suffice for knowledge.
- Identities: free-form strings, but stable per person/role within a Brain (`"@sofia"`, `"sofia@acme.io"`, `"@release-captain"`). The standard imposes no identity system (P2: Git already has one; `verified` complements the commit trail, not replaces it).
- Durations: integer + unit `d`/`w`/`m`/`y`.
