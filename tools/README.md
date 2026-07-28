# Tools — pointers only

This directory will never contain tools. It will contain **pointers** to implementations of the standard, starting with the reference CLI (v0.4 target, separate repository) — see [`ARCHITECTURE.md`](../ARCHITECTURE.md): tools are Layer 2/4; this repository is Layer 1.

Planned reference CLI surface (indicative, non-normative):

```
brain init          # scaffold a Level 1 brain
brain validate      # check conformance at the claimed level
brain pack <intent> # assemble a Context Pack deterministically
brain triage        # review the candidates inbox (promotion stays human)
brain gc            # expired candidates, past-due reviews
```

Where any tool and the spec disagree, the tool is wrong (Principle P10).
