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
metrics: statement, branch, condition and FSM. Toggle and expression coverage
are not TRL-5 metrics. Testbench code is not counted.

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
   `-fstate`/`-ftrans`, and condition rows use `-feccondrow`. Every command has a
   mandatory `-comment` that states the consequence of the category for those
   lines. The comment appears in the Questa report next to the excluded item.

`-du` applies the command to every instance of the design unit. `-scope`
restricts it to one instance, when the item is reachable in other instances.

### Categories

| # | Category | Cause | Commands | Holes (S / B / C / FSM) | Proofs |
| --- | --- | --- | ---: | ---: | --- |
| 1 | Undriven rounding modes: RMM/ROD | RMM is legal but not stimulated (the reference model cannot check it). ROD and the reserved encodings never reach the arithmetic units. | 11 | 36 (18 / 18 / 0 / 0) | [`cat1_rounding_modes.md`](details/cat1_rounding_modes.md) |
| 2 | FPU config: vector operations are disabled | `XFVec = 0`: scalar only, so the SIMD paths are dead. | 68 | 126 (54 / 61 / 11 / 0) | [`cat2_disabled_vector_ops.md`](details/cat2_disabled_vector_ops.md) |
| 3 | FPU config: FP8 and FP16ALT formats are disabled | `XF8 = XF16ALT = 0`. | 11 | 31 (2 / 29 / 0 / 0) | [`cat3_disabled_formats.md`](details/cat3_disabled_formats.md) |
| 4 | FPU config: DIVSQRT and CONV use MERGED units | Only the first format slot of a MERGED operation group raises requests. | 8 | 28 (0 / 28 / 0 / 0) | [`cat4_unit_type.md`](details/cat4_unit_type.md) |
| 5 | `fpu_wrap` ties `fpu_out_ready` to 1 | The FPU output is never stalled. | 17 | 25 (8 / 8 / 5 / 4) | [`cat5_out_ready.md`](details/cat5_out_ready.md) |
| 6 | Structurally unreachable | Complete case/default arms, padding, protocol invariants, and other tie-offs not covered above. | 46 | 110 (28 / 57 / 25 / 0) | [`cat6_structural.md`](details/cat6_structural.md) |
| | **Total** | | **161** | **356** | |

Holes are counted in the regression (pre-waiver `merged.ucdb`): S =
statement, B = branch, C = condition FEC row, FSM = state or transition. After
the waivers, coverage is 100% on all four metrics.

Numbering notes:
- Section 1.2 of `cat1_rounding_modes.md` (ROD) has no `# 1.2` header in
  `exclude.do`. The ROD arm of `fpnew_rounding` sits on the same lines as the
  RMM arm, so the `fpnew_rounding` commands under `# 1.1` waive both, and their
  comment names both.
- Condition holes are listed per FEC row in the register. Questa's condition
  bins count input terms, so the two counts differ.

## Open items

- **RMM (round to nearest, ties to max magnitude)** is legal in RISC-V and
  implemented by the RTL, but it is not verified. The MPFR-based reference
  model has no ties-away-from-zero rounding, so the stimulus does not issue RMM.
  The affected lines are in category 1.1 of `exclude.do`. Closing it needs a reference model with
  RMM (e.g. SoftFloat) and the stimulus constraints on `rm`/`frm` opened.
