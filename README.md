# Sidorenko counterexample C≤1641 — first Lean-Verified build (standard axioms only)

A standalone, reproducible Lean 4 build of the **comparator challenge
`SidorenkoCounterexample`** from OpenAI's Math release:

> OpenAI, *A counterexample to Sidorenko's conjecture*, September 23, 2026 —
> family 161 of the October 6, 2026 `openai/math` release.
> Preprint: <https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/A-counterexample-to-Sidorenkos-conjecture-September-23-2026/paper.pdf>
> Scope note: <https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/lean/docs/161.md>
> Comparator challenge: `lean/ComparatorChallenges/SidorenkoCounterexample.lean`
> Solution module: `lean/OAI/Combinatorics/Sidorenko/RandomHost.lean`

**The statement proved** (verbatim from the upstream challenge file):

```lean
theorem main : ∃ size : ℕ, 0 < size ∧ ∃ host : SimpleGraph (Fin size),
    (∃ left right, host.Adj left right) ∧ homDensity H host < (edgeDensity host) ^ 66
```

where `H` is the fixed bipartite incidence graph of the 22 triples on 13 points
from Table 1 of the paper (35 vertices, 66 edges), `homDensity` counts all
edge-preserving maps (including noninjective ones), and `edgeDensity` is
`2|E|/|V|²`. In words: **there is a nonempty finite simple graph whose
H-homomorphism density is strictly below the Sidorenko lower bound
(edge density)^66** — a finite counterexample to Sidorenko's conjecture for
this pattern.

## Attribution

All mathematical content — the 35 proof files under `OAI/Combinatorics/Sidorenko/`
(~23,800 lines) — is copied **verbatim** from
[`openai/math`](https://github.com/openai/math) @ `adc7f1241b42e322a6451854ab7e4b4c146bf78a`
(lean folder, Apache 2.0; see `LICENSE`). The construction and proof are due to
OpenAI's Math release. This repository only:

1. packages the Sidorenko family's actual import closure (Mathlib + internal
   `OAI.Combinatorics.Sidorenko.*` — nothing else) so it builds standalone;
2. restates the comparator challenge with its `sorry` closed by
   `exact OAI.SidorenkoCounterexample.main` (a real definitional-equality check
   of the upstream theorem's type against the freshly elaborated challenge
   statement) in `Verify/SidorenkoCounterexample.lean`;
3. records the axiom audit and exact build commands.

No proof step was altered. The 35 committed `OAI/` blobs are byte-identical to
the upstream `lean/OAI/Combinatorics/Sidorenko/` blobs of `openai/math` @
`adc7f124`; compare them with
`git cat-file -p HEAD:OAI/... | shasum -a 256` against the upstream blob, or
`diff -r OAI/ upstream/lean/OAI/` on a checkout.

## Build (exact commands)

Requirements: `elan` (installs the pinned toolchain automatically), `git`, ~8 GB
disk. Internet needed once to fetch Mathlib and its cached oleans.

```bash
git clone https://github.com/darkhipo/sidorenko-counterexample-lean
cd sidorenko-counterexample-lean
lake update
lake exe cache get      # Mathlib oleans for the pinned commit (minutes)
lake build Verify.SidorenkoCounterexample
```

## Pins

- Lean toolchain: `leanprover/lean4:v4.34.1` (same as upstream `lean-toolchain`)
- Mathlib: `d13f23b723b8a846827a245b89c10fc7d3f11612` (same pin as upstream `lakefile.lean`)
- openai/math source: `adc7f1241b42e322a6451854ab7e4b4c146bf78a`

## Integrity check

`.gitattributes` pins `* text=auto eol=lf`, so every clone checks out exactly the
bytes the manifests describe (independently of `core.autocrlf`).

```bash
shasum -c SHA256SUMS          # 35 upstream `OAI/` files, byte-identical to openai/math blobs
shasum -c SHA256SUMS.verify   # this repo's addition: Verify/SidorenkoCounterexample.lean
```

Both commands exit 0 and print `OK` for every listed file.

Provenance note: upstream's `openai/math` challenge file itself is **not**
vendored (only the namespace-adjusted copy under `Verify/` is), so it does not
appear in either manifest. Its digest is recorded here for audit:
`lean/ComparatorChallenges/SidorenkoCounterexample.lean` @ `adc7f124` =
`3f2b1aba5bb6b6644562f19516eb32ceac9cccf9d07d8c9f002d4ea73e5b226b`; the
committed `Verify/` copy differs from it only in the outer namespace and the
closing `exact`.

## Axiom audit

Run after building:

```bash
lake env lean Verify/SidorenkoCounterexample.lean
```

Expected output (also recorded in `AXIOM_AUDIT.txt`):

```
'Verify.SidorenkoCounterexample.main' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Only the three standard axioms. No `sorryAx`, no custom axioms. The `#print
axioms` line is part of the source file, so `lake build` itself re-emits it on
every build.

## What this is / is not

- ✅ First **Lean-Verified** row for the Sidorenko counterexample problem:
  the exact OpenAI comparator statement, proved with standard axioms only.
- ✅ Reproducible from a clean clone with the commands above.
- ❌ Not the numerical leader: the certificate bound here is the upstream
  artifact's own (see `random host` construction in `RandomHost.lean`; the
  `1642 ≤ D₀` dichotomy in `Tail.lean` is an internal exponent threshold, not
  the board's C-metric). Tightening toward C≤189 is future work and needs the
  board's sizing rules.
- ❌ Not the forcing-conjecture consequence (explicitly outside the upstream
  formalization scope).

## Layout

```
OAI/Combinatorics/Sidorenko/   # 35 files, verbatim from openai/math @ adc7f12
Verify/SidorenkoCounterexample.lean  # challenge statement (verbatim) + sorry closed + #print axioms
lakefile.lean                  # Mathlib pin, two lean_libs
lean-toolchain                 # v4.34.1
LICENSE                        # Apache 2.0 (from upstream lean folder)
AXIOM_AUDIT.txt                # recorded audit output
.gitattributes                 # * text=auto eol=lf — keeps checkout bytes stable
SHA256SUMS                     # 35 upstream OAI/ files (sha256 of committed bytes)
SHA256SUMS.verify              # Verify/SidorenkoCounterexample.lean (this repo's addition)
```

## License

Apache 2.0, matching the upstream `openai/math` lean folder license.
