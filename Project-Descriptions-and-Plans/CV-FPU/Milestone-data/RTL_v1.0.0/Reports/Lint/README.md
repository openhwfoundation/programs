<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# CV-FPU v1.0.0 — RTL lint report

## Tool and scope

| Item | Value |
| --- | --- |
| Linter | Verilator 5.048 (`verilator --lint-only -Wall`) |
| Top | `lint/lint_top.sv` of cvfpu-uvm: instantiates `fpu_wrap` with the verified configuration (`cv64a60ax`: RVF, RVD, XF16; `XFVec = XF8 = XF16ALT = 0`; `DivSqrtSel = THMULTI`) and the same port types as the testbench, without UVM |
| Sources | `lint/dut.f` of cvfpu-uvm: the design-only subset of the Bender file list. That is fpnew `v1.0.0` with its vendored C910/E906/CVW RTL, common_cells, tech_cells_generic `src/rtl`, and `fpu_wrap` |
| Out of scope | The CVA6 packages (`cv64a60ax_config_pkg_cvfpu-uvm.sv`, `obi_pkg`, `config_pkg`, `build_config_pkg`, `riscv_pkg`, `ariane_pkg`). They are compiled only to build `fpu_wrap`, and they are not part of this release |
| Log | `verilator_lint.log` (this folder) |

The command and the reason for the wrapper are in `lint/README.md` of
cvfpu-uvm.

## Result

**No errors.** The log ends with `%Error: Exiting due to 674 warning(s)`
because `-Wall` makes warnings fatal. There is no other `%Error`.

180 of the 674 warnings are in the out-of-scope CVA6 packages and are not
counted here. The remaining 494 are all waived:

| Warning | Count | Outside the DUT | Waiver reason |
| --- | ---: | ---: | --- |
| WIDTHEXPAND | 158 | 0 | Implicit widening never drops bits. 48 are `DONT_CARE` patterns in `unique case` items. The others widen exponent or mantissa operands to the width of the expression, and signed comparisons (`LTES`, `GTES`, `LTS`) are sign-extended. The arithmetic is checked bit-exactly against the reference model. |
| ASCRANGE | 101 | 0 | fpnew declares format and lane arrays `[0:N-1]` on purpose (`fmt_logic_t`, lane arrays) and indexes them consistently. Bit order is a style choice with no functional effect. |
| UNUSEDSIGNAL | 82 | 1 | Bits or signals with no load in this configuration: vector lanes, disabled formats, upper or guard bits of internal buses, C910 outputs that fpnew does not read, the unused `fpu_prec_i` of `fpu_wrap`, and the pass-through `gated_clk_cell` inputs. Unused logic cannot affect results. The one outside the DUT is in `lint_top.sv`. |
| WIDTHTRUNC | 46 | 0 | Each truncation was checked. 29 assign 32-bit integer expressions (bias, shift amounts, exponent offsets) to exponent or shift fields that fpnew sizes to hold every reachable value. 12 (4 per FP format) drop the carry bit of the FMA sum, which the source documents as intentional (`sum`, and `small_norm`, where the carry is checked before the assignment). 1 drops the extension bit in the FP64 slice, where the result already fills the 64-bit width. 2 use `TrueSIMDClass` as a boolean. 1 is the 1-bit `vec_op` reset value `'0`. 1 is an `ASSERT_INIT` in `rr_arb_tree`. |
| GENUNNAMED | 45 | 14 | Unnamed generate blocks only affect hierarchical names. |
| PINCONNECTEMPTY | 42 | 32 | Outputs left open on purpose: `idx_o` of `rr_arb_tree`, `busy_o` of `fpnew_top` in `fpu_wrap`, `empty_o` of `lzc`, and the C910 debug and register-write-back outputs that fpnew does not use. The 32 outside the DUT are in common_cells and fpnew modules that are compiled but not instantiated. |
| UNUSEDPARAM | 8 | 1 | Format and operation constants with no use in this configuration (`fpnew_pkg`, `fpnew_opgroup_multifmt_slice`, common_cells `cb_filter_pkg`). They generate no hardware. |
| DECLFILENAME | 7 | 7 | Files that hold more than one module: common_cells (6) and `tc_clk.sv`. None is instantiated in the DUT. |
| UNDRIVEN | 2 | 0 | See below. |
| UNSIGNED | 2 | 0 | See below. |
| SYNCASYNCNET | 1 | 1 | See below. |

"Outside the DUT" counts warnings in files that are compiled but not
instantiated under `fpu_wrap`, and in `lint_top.sv`. These include most of
common_cells, tech_cells_generic, `fpnew_divsqrt_th_32` with the E906 divider,
`fpnew_fma_multi` and the CVW `fmalza`.

### Warnings reviewed individually

- **UNSIGNED**, `common_cells/src/rr_arb_tree.sv` lines 198–199:
  `(i > rr_q)` / `(i <= rr_q)` at `i = 0` compare against an unsigned value, so
  they are constant. Waiver
  [6.13](../../Waivers/details/cat6_structural.md#s6-13) relies on the same
  fact, which the linter confirms here independently.
- **UNDRIVEN**, `fpnew_opgroup_multifmt_slice.sv`, `divsqrt_done[0]` and
  `divsqrt_ready[0]`: in the CONV-group instance, lane 0 is a
  `fpnew_cast_multi`, which has no `divsqrt_*` outputs. The only consumers of
  these bits, through `simd_synch_done`/`simd_synch_rdy`, are the
  `fpnew_divsqrt_th_64_multi` ports, and that divider exists only in the
  DIVSQRT-group instance, where both bits are driven.
- **SYNCASYNCNET**, `rst_ni`: async reset in `fpu_wrap`, and also sampled in
  the `disable iff` of the `hot_one` assertion in `rr_arb_tree`. The assertion
  is not design logic.

`verilator_lint.log` lists every instance.
