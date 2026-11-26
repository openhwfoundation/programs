<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# CV-FPU v1.0.0 — code coverage waivers

This folder explains every code coverage item that the CV-FPU v1.0.0 regression
does not hit, and why it is waived.

| File | Content |
| --- | --- |
| [`exclude.do`](exclude.do) | The waiver script that was applied: an exact copy of `simu/tools/vsim/exclude.do` in cvfpu-uvm v1.0.0. |
| [`details/`](details/) | One proof file per category. Each sub-category has a numbered section; `exclude.do` uses the same numbers. |
| [`../CVFPU_waiver_list.xlsx`](../CVFPU_waiver_list.xlsx) | Register of every waived item: one row per `exclude.do` command, with lines, hole count, scope and the link to its proof. |

## What is waived

Waivers apply only to the DUT, `/top/dut` (`fpu_wrap` and everything below it:
`fpnew_top` and the vendored divider RTL), and only to the TRL-5 code coverage
metrics: statement, branch, condition, expression and FSM. Toggle coverage is
not a TRL-5 metric. Testbench code is not counted.

An item is waived only if it is **structurally unreachable** in the verified
configuration. That means a parameter of the configuration, a tie-off, or a
protocol invariant prevents it from ever being exercised. Waiving an item
because the stimulus happens not to reach it is not allowed. The one exception
is RMM, category 1.1, a legal feature that is not verified; it is listed as an
open item below.

Verified configuration: CVA6 `cv64a60ax` (RVF, RVD, XF16; `XFVec = XF8 =
XF16ALT = 0`), `DivSqrtSel = THMULTI`, `fpu_wrap` with `fpu_out_ready` tied to 1.

## How `exclude.do` is organised

`exclude.do` is a Questa Tcl script made of `coverage exclude` commands. It is
grouped in three levels:

1. **Category**, a `# N: <title>` header: the root cause, for example a
   disabled configuration option.
2. **Sub-category**, a `# N.M <title>` header: one specific mechanism inside
   that cause. Each sub-category has a section `N.M` in `details/catN_*.md`
   with the list of items and the proof.
3. **Command**: `coverage exclude -du <design unit> -code <s|b|c> -linerange
   <lines> [-scope <instance>] -comment {<reason>}`. FSM items use
   `-fstate`/`-ftrans`, condition rows use `-feccondrow`, and expression rows
   use `-item e 1 -fecexprrow <line> <rows>`. Every command has a
   mandatory `-comment` that states the consequence of the category for those
   lines. The comment appears in the Questa report next to the excluded item.

`-du` applies the command to every instance of the design unit. `-scope`
restricts it to one instance, when the item is reachable in other instances.
An expression inside a `for`-generate loop belongs to the scope of its loop
iteration (for example `…/gen_lzc/g_levels[2]/g_last_level/g_level[1]/g_reduce`),
which the Questa report shows as `GI=<level>,<index>`, so those rows are
excluded with `-scope` on that iteration.

An expression row is waived only if it has no hits and the term it targets is
structurally unreachable. A ternary (bimodal) row has one hit count per output
value; `-col 1` waives only its output-1 column. This is used once, for
`fpu_wrap` `fpu_vec_op = use_hold ? fpu_vec_op_q : fpu_vec_op_d` (2.6): both
`use_hold` rows hit only with output 0, and output 1 is unreachable. Their
output-0 hits stay in the report.

### Categories

| # | Category | Cause | Commands | Holes (S / B / C / E / FSM) | Proofs |
| --- | --- | --- | ---: | ---: | --- |
| 1 | Undriven rounding modes: RMM/ROD | RMM is legal but not stimulated (the reference model cannot check it). ROD and the reserved encodings never reach the arithmetic units. | 15 | 68 (18 / 18 / 0 / 32 / 0) | [`cat1_rounding_modes.md`](details/cat1_rounding_modes.md) |
| 2 | FPU config: vector operations are disabled | `XFVec = 0`: scalar only, so the SIMD paths are dead. | 80 | 169 (54 / 61 / 11 / 43 / 0) | [`cat2_disabled_vector_ops.md`](details/cat2_disabled_vector_ops.md) |
| 3 | FPU config: FP8 and FP16ALT formats are disabled | `XF8 = XF16ALT = 0`. | 33 | 120 (2 / 29 / 0 / 89 / 0) | [`cat3_disabled_formats.md`](details/cat3_disabled_formats.md) |
| 4 | FPU config: DIVSQRT and CONV use MERGED units | Only the first format slot of a MERGED operation group raises requests. | 27 | 180 (0 / 28 / 0 / 152 / 0) | [`cat4_unit_type.md`](details/cat4_unit_type.md) |
| 5 | `fpu_wrap` ties `fpu_out_ready` to 1 | The FPU output is never stalled. | 20 | 32 (8 / 8 / 5 / 7 / 4) | [`cat5_out_ready.md`](details/cat5_out_ready.md) |
| 6 | Structurally unreachable | Complete case/default arms, padding, protocol invariants, and other tie-offs not covered above. | 77 | 274 (28 / 57 / 25 / 164 / 0) | [`cat6_structural.md`](details/cat6_structural.md) |
| | **Total** | | **252** | **843** | |

Holes are counted in the regression (pre-waiver `merged.ucdb`): S =
statement, B = branch, C = condition FEC row, E = expression FEC row with no
hits, FSM = state or transition. The 487 expression rows cover 374 expression
terms (Questa's expression bins). After the waivers, coverage is 100% on all
five metrics.

Numbering notes:
- The statement and branch items of section 1.2 (ROD) are under the `# 1.1`
  header of `exclude.do`. The ROD arm of `fpnew_rounding` sits on the same
  lines as the RMM arm, so the `fpnew_rounding` commands under `# 1.1` waive
  both, and their comment names both. The `# 1.2` header holds only the
  expression rows of the ROD arm.
- Condition and expression holes are listed per FEC row in the register.
  Questa's condition and expression bins count input terms, so the counts
  differ.

## Open items

- **RMM (round to nearest, ties to max magnitude)** is legal in RISC-V and
  implemented by the RTL, but it is not verified. The MPFR-based reference
  model has no ties-away-from-zero rounding, so the stimulus does not issue RMM.
  The affected lines are in category 1.1 of `exclude.do`. Closing it needs a reference model with
  RMM (e.g. SoftFloat) and the stimulus constraints on `rm`/`frm` opened.
