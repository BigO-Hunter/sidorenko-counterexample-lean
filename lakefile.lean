import Lake
open Lake DSL

package «sidorenko-counterexample» where
  version := v!"0.1.0"
  leanOptions := #[⟨`autoImplicit, false⟩]

-- Same Mathlib pin as openai/math @ adc7f1241b42e322a6451854ab7e4b4c146bf78a.
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "d13f23b723b8a846827a245b89c10fc7d3f11612"

@[default_target]
lean_lib OAI where
  globs := #[.submodules `OAI.Combinatorics.Sidorenko]

@[default_target]
lean_lib Verify where
  roots := #[`Verify.SidorenkoCounterexample]
