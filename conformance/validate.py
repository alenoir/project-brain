#!/usr/bin/env python3
"""Project Brain conformance validator (spec 0.1).

Usage:
    python3 validate.py [BRAIN_ROOT] [--strict]

BRAIN_ROOT is the directory containing brain.yaml (default: ./.brain).
--strict turns warnings into errors.

Exit codes: 0 conformant, 1 violations found, 2 could not run.

Single file, stdlib + PyYAML (pip install pyyaml). This validator checks a
brain against the requirements of its *claimed* conformance level (spec
chapter 01) and reports violations without modifying anything. Where this
tool and the spec disagree, the spec wins (Principle P10).
"""

import re
import sys
from datetime import date, timedelta
from pathlib import Path

try:
    import yaml
except ImportError:  # pragma: no cover
    sys.stderr.write(
        "project-brain validate: PyYAML is required (pip install pyyaml)\n"
    )
    sys.exit(2)

TYPES = {
    "overview", "state", "architecture", "decision", "rule",
    "invariant", "guide", "knowledge", "note",
}
STATUSES = {"draft", "active", "needs-review", "deprecated", "archived"}
AUTHORITIES = {"canonical", "informative", "candidate", "deprecated", "archived"}
PROVENANCES = {"human", "agent", "mixed", "imported"}
KNOWN_FIELDS = {
    "id", "type", "title", "status", "authority", "provenance", "created",
    "updated", "verified", "superseded_by", "supersedes", "review_by",
    "expires", "review_every", "review_note", "deprecation_note",
    "generator", "authors", "relates_to", "scope", "sources", "tags",
}
CANDIDATE_STALE_DAYS = 90


class Report:
    def __init__(self, strict=False):
        self.errors, self.warnings = [], []
        self.strict = strict

    def error(self, path, msg):
        self.errors.append((str(path), msg))

    def warn(self, path, msg):
        (self.errors if self.strict else self.warnings).append((str(path), msg))

    def dump(self):
        for label, items in (("ERROR", self.errors), ("WARN ", self.warnings)):
            for path, msg in items:
                print(f"{label}  {path}: {msg}")
        n_e, n_w = len(self.errors), len(self.warnings)
        print(f"\n{n_e} error(s), {n_w} warning(s)")
        return 1 if self.errors else 0


def parse_date(value):
    if isinstance(value, date):
        return value
    if isinstance(value, str) and re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
        try:
            return date.fromisoformat(value)
        except ValueError:
            return None
    return None


def load_yaml(path, rep):
    try:
        with open(path, encoding="utf-8") as f:
            data = yaml.safe_load(f)
    except Exception as exc:
        rep.error(path, f"unparseable YAML: {exc}")
        return None
    if not isinstance(data, dict):
        rep.error(path, "expected a YAML mapping")
        return None
    return data


def front_matter(path, rep):
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return None, "no metadata block (YAML front matter) at top of file"
    end = text.find("\n---", 4)
    if end == -1:
        return None, "unterminated metadata block"
    try:
        meta = yaml.safe_load(text[4:end])
    except Exception as exc:
        return None, f"unparseable metadata block: {exc}"
    if not isinstance(meta, dict):
        return None, "metadata block is not a mapping"
    return meta, None


def check_item(path, meta, level, rep, today):
    rel = path
    required = ["id", "type", "title", "status", "authority", "provenance",
                "created", "updated"]
    if level >= 2:
        for field in required:
            if field not in meta:
                rep.error(rel, f"missing required field '{field}' (Level 2+)")

    item_type = meta.get("type")
    status = meta.get("status")
    authority = meta.get("authority")
    provenance = meta.get("provenance")

    if item_type is not None and item_type not in TYPES:
        rep.error(rel, f"unknown type '{item_type}'")
    if status is not None and status not in STATUSES:
        rep.error(rel, f"unknown status '{status}'")
    if authority is not None and authority not in AUTHORITIES:
        rep.error(rel, f"unknown authority '{authority}'")
    if provenance is not None and provenance not in PROVENANCES:
        rep.error(rel, f"unknown provenance '{provenance}'")

    for field in ("created", "updated", "review_by", "expires"):
        if field in meta and parse_date(meta[field]) is None:
            rep.error(rel, f"'{field}' is not an ISO date (YYYY-MM-DD)")

    item_id = meta.get("id")
    if isinstance(item_id, str) and not re.fullmatch(r"[a-z0-9.-]+", item_id):
        rep.warn(rel, f"id '{item_id}' not in recommended form (lowercase, digits, dots, dashes)")

    # Authority/verification coupling (spec 5.1, 6.2)
    if authority == "canonical":
        verified = meta.get("verified")
        if not isinstance(verified, dict) or "by" not in verified or "at" not in verified:
            rep.error(rel, "authority: canonical requires verified.by and verified.at (spec 5.1)")
        if item_type == "note":
            rep.error(rel, "type: note must not be canonical (spec 4.3)")

    # Status/authority coupling (spec 7.1)
    for s in ("deprecated", "archived"):
        if status == s and authority != s:
            rep.error(rel, f"status: {s} forces authority: {s} (spec 7.1)")

    # Type-specific rules
    if item_type == "state" and level >= 2 and "review_by" not in meta:
        rep.error(rel, "type: state requires review_by (spec 4.3)")
    if status == "deprecated" and "superseded_by" not in meta:
        rep.warn(rel, "deprecated without superseded_by (spec 7.2: required when a replacement exists)")

    # Freshness (spec 7.5)
    rb = parse_date(meta.get("review_by")) if "review_by" in meta else None
    if rb and rb < today and status not in ("needs-review", "deprecated", "archived"):
        rep.warn(rel, f"past review_by ({rb}) — readers must treat as needs-review")
    ex = parse_date(meta.get("expires")) if "expires" in meta else None
    if ex and ex < today:
        rep.warn(rel, f"expired ({ex}) — binds no one")

    # Unknown non-namespaced fields
    for key in meta:
        if key not in KNOWN_FIELDS and not str(key).startswith("x-"):
            rep.warn(rel, f"unknown field '{key}' (extensions should be namespaced 'x-')")

    return item_id


def check_area_rules(root, path, meta, rep, today):
    rel_parts = path.relative_to(root).parts
    area = rel_parts[0] if len(rel_parts) > 1 else None
    authority = meta.get("authority")
    status = meta.get("status")

    if area == "candidates":
        if authority not in (None, "candidate"):
            rep.error(path, f"items under candidates/ must have authority: candidate, found '{authority}' (spec 6.3)")
        if isinstance(meta.get("verified"), dict):
            rep.error(path, "candidates must not carry verified blocks (spec 6.3)")
        created = parse_date(meta.get("created"))
        if created and (today - created) > timedelta(days=CANDIDATE_STALE_DAYS):
            rep.warn(path, f"stale candidate (created {created}, > {CANDIDATE_STALE_DAYS} days) — promote, delete, or archive (spec 6.3)")
    elif area == "archive":
        if status != "archived" or authority != "archived":
            rep.warn(path, "items under archive/ should have status and authority 'archived' (spec 3.3)")


def check_context(root, manifest, rep):
    ctx_path = root / manifest.get("context", "context/manifest.yaml")
    if not ctx_path.is_file():
        return False
    ctx = load_yaml(ctx_path, rep)
    if ctx is None:
        return True
    for field in ("context", "default", "packs"):
        if field not in ctx:
            rep.error(ctx_path, f"missing required field '{field}' (spec 8.1)")
    packs = ctx.get("packs") or {}
    if isinstance(packs, dict):
        if ctx.get("default") and ctx["default"] not in packs:
            rep.error(ctx_path, f"default pack '{ctx['default']}' not defined in packs")
        for name, spec_ in packs.items():
            file_ = (spec_ or {}).get("file")
            if not file_:
                rep.error(ctx_path, f"pack '{name}' has no file")
                continue
            pack_path = ctx_path.parent / file_
            if not pack_path.is_file():
                rep.error(ctx_path, f"pack '{name}' file not found: {file_}")
                continue
            pack = load_yaml(pack_path, rep)
            if pack is None:
                continue
            for field in ("pack", "intent"):
                if field not in pack:
                    rep.error(pack_path, f"missing required field '{field}' (spec 8.2)")
            if "required" not in pack:
                rep.error(pack_path, "missing 'required' list (spec 8.2 — may be empty, not absent)")
            entries = list(pack.get("required") or []) + list(pack.get("recommended") or [])
            for od in pack.get("on_demand") or []:
                entries += list((od or {}).get("load") or [])
            for entry in entries:
                if not isinstance(entry, str):
                    rep.error(pack_path, f"non-string pack entry: {entry!r}")
                    continue
                target = root / entry
                if not (target.is_file() or target.is_dir()):
                    rep.error(pack_path, f"pack entry not found in brain: {entry}")
    return True


def main(argv):
    args = [a for a in argv[1:] if not a.startswith("--")]
    strict = "--strict" in argv
    root = Path(args[0]) if args else Path(".brain")
    if not root.is_dir() or not (root / "brain.yaml").is_file():
        sys.stderr.write(f"project-brain validate: no brain.yaml under '{root}'\n")
        return 2

    rep = Report(strict=strict)
    today = date.today()

    manifest = load_yaml(root / "brain.yaml", rep)
    if manifest is None:
        rep.dump()
        return 1

    for field in ("spec", "conformance", "entry"):
        if field not in manifest:
            rep.error(root / "brain.yaml", f"missing required field '{field}' (spec 3.2)")
    level = manifest.get("conformance")
    if level not in (1, 2, 3):
        rep.error(root / "brain.yaml", f"conformance must be 1, 2 or 3, found {level!r}")
        level = 1
    entry = manifest.get("entry")
    if entry and not (root / entry).is_file():
        rep.error(root / "brain.yaml", f"entry file not found: {entry}")

    if not (root / "overview.md").is_file() and entry != "overview.md":
        rep.warn(root, "no overview.md (recommended entry point)")

    seen_ids = {}
    items = sorted(root.rglob("*.md"))
    for path in items:
        meta, err = front_matter(path, rep)
        if err:
            if level >= 2:
                rep.error(path, err)
            else:
                rep.warn(path, err)
            continue
        item_id = check_item(path, meta, level, rep, today)
        check_area_rules(root, path, meta, rep, today)
        if item_id:
            if item_id in seen_ids:
                rep.error(path, f"duplicate id '{item_id}' (also in {seen_ids[item_id]})")
            else:
                seen_ids[item_id] = path

    # Cross-references
    for path in items:
        meta, err = front_matter(path, Report())  # errors already reported
        if not meta:
            continue
        refs = [meta.get("superseded_by"), meta.get("supersedes")]
        refs += list(meta.get("relates_to") or [])
        for ref in refs:
            if isinstance(ref, str) and ref not in seen_ids:
                rep.warn(path, f"reference to unknown id '{ref}'")

    has_context = check_context(root, manifest, rep)
    if level >= 3 and not has_context:
        rep.error(root, "Level 3 requires a context manifest with a default pack (spec 1.2)")

    code = rep.dump()
    if code == 0:
        print(f"brain at '{root}' conforms to its claimed Level {level} (spec {manifest.get('spec')})")
    return code


if __name__ == "__main__":
    sys.exit(main(sys.argv))
