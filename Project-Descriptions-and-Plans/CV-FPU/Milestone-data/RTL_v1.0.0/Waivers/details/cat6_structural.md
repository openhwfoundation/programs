<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# [Category 6] Structurally unreachable

These holes do not follow from the configuration choices in categories 1–5.
Each is ruled out by the RTL itself: a case statement that already enumerates
every known value, a constant tie-off inside fpnew or the C910 integration, an
operation that the decode never produces, or a protocol invariant.

<a id="s6-1"></a>
## 6.1 Static rounding mode tied to 111 (C910 prepare)

**Items.** `ct_vfdsu_prepare`,
`ex1_rm = ((ex1_static_rm == 3'b111) || !ex1_scalar) ? vfpu_yy_xx_rm : ex1_static_rm`:
the false arm and the FEC rows with `ex1_static_rm != 7`.

**Why.** `fpnew_divsqrt_th_64_multi` ties `dp_vfdsu_ex1_pipex_imm0` (the
static rounding mode) to `3'b111`. The external `rm` input is therefore always
selected, and carries the resolved rounding mode.

<a id="s6-2"></a>
## 6.2 Double and single format flags never both set (C910 round)

**Items.** `ct_vfdsu_round`, `case ({total_qt_rt_58[56], vfdsu_ex3_double, vfdsu_ex3_single})`:
the `default` arm and its statements.

**Why.** The listed arms enumerate every combination with at most one of
`double`/`single` set, so the default needs both set. Both flags come from the
wrapper's `divsqrt_fmt`, which is one-hot (FP64 = 1000, FP32 = 0100,
FP16 = 0010), so they are never both 1.

<a id="s6-3"></a>
## 6.3 ADDS is never issued

**Items.**
- `fpnew_fma`: the `ADDS` label of the `ADD, ADDS` case arm, in each ADDMUL FMA.
- `fpnew_opgroup_multifmt_slice`, operand-2 shift
  `fp_width(op_i == ADDS ? src_fmt_i : dst_fmt_i)`: the `ADDS` arm and its FEC
  row.

**Why.** `fpu_wrap` decodes FADD and FSUB to `fpnew_pkg::ADD`; no CVA6
operation maps to `ADDS`.

<a id="s6-4"></a>
## 6.4 DIVSQRT has no third operand

**Items.** `fpnew_opgroup_multifmt_slice`, DIVSQRT lane, `prepare_input`:
- the `if (i == 2)` arm, its statement and its FEC row;
- the remaining arm and FEC row of the `op_i == ADDS` ternary inside it.

**Why.** `fpnew_pkg::num_operands(DIVSQRT) = 2`, so the loop runs for i = 0, 1
only, and the `i == 2` body is never executed in this group. The CONV group
has 3 operands, and the same code is measured there.

<a id="s6-5"></a>
## 6.5 Default arms of complete case statements (C910)

**Items.**
- `ct_vfdsu_ctrl`, SRT next-state case: `default`. The state is one bit, and
  both SRT_IDLE and SRT_BUSY are listed.
- `ct_vfdsu_ff1`, leading-one `casez` on a 52-bit fraction: `default`. The
  patterns cover `1?…?`, `01?…?`, …, `0…01` and the all-zero value.
- `ct_vfdsu_pack`, both `casez (ex4_frac[54:53])`: `default`. The patterns
  `00`, `01` and `1?` cover all four values.

**Why.** For every 0/1 value of the selector, an explicit arm matches. The
default is reachable only with X/Z on the selector, which reset prevents and
two-state coverage does not count.

<a id="s6-6"></a>
## 6.6 SRT bound-table default

**Items.** `ct_vfdsu_srt_radix16_bound_table`, first `case (bound_sel)`: the
`default` arm and its statements.

**Why.** The case lists `7'h00` and `7'h40`–`7'h7f`, so the default needs
`bound_sel` ∈ 01–3f, i.e. `bound_sel[6] = 0` with a non-zero value. `bound_sel`
is a register in `ct_vfdsu_srt_radix16_with_sqrt`:

| Event | Value loaded |
| --- | --- |
| Reset | 0 |
| SRT start, divide | `initial_divisor_in[55:49]` = top 7 bits of the normalised divisor `{ex1_divisor[52:0], 3'b0}`: MSB = 1, so 40–7f |
| SRT start, square root | 0 |
| Each square-root iteration | `total_qt_rt_next[56:50]` |
| Otherwise | hold |

Only the square-root row needs an argument.

*Scaling.* `QT_WIDTH = 58`. The root register `total_qt_rt` gets digit *j*
(radix 16, *d* ∈ {−9…9}) at the bit of `qt_rt_const_shift_std`, which is
loaded with bit 54 at SRT start and shifted right by 4 every iteration. Take
bit 58 as weight 1. The partial root is then *P*ⱼ = Σ *d*ᵢ·16⁻ⁱ, bit 57 has
weight 1/2 and bit 56 has weight 1/4.
- The remainder update for digit +1 adds `~({4'b0, total_qt_rt[57:1]} | qt_rt_const_q1[62:2])`.
- For digit +2 it adds `~({3'b0, total_qt_rt[57:0]} | qt_rt_const_q4[62:2])`.

Both match the square-root recurrence *w*ⱼ = 16·*w*ⱼ₋₁ − 2·*P*ⱼ₋₁·*d*ⱼ − *d*ⱼ²·16⁻ʲ
once remainder bit *i* has weight 2^(*i*−56). The initial remainder
`{2'b00, ex1_remainder[59:1]}` places the operand's leading 1
(`sqrt_remainder`, `ct_vfdsu_prepare`) at bit 52 (even exponent) or bit 53
(odd exponent). The radicand is therefore *x* ∈ [1/16, 1/4), which matches the
`sqrt : 1/16 <= x < 1/4` note in `ct_vfdsu_prepare`, so √*x* ∈ [1/4, 1/2).

*Convergence.* With 9 as the largest digit in radix 16, the redundancy factor is
ρ = 9/15 = 3/5. A residual kept in bounds by digit selection is equivalent to
|√*x* − *P*ⱼ| ≤ ρ·16⁻ʲ at every iteration *j*. This is the convergence property
of the SRT square-root recurrence. Every correctly computed root depends on it:
the digits after *j* can still move the root by at most ρ·16⁻ʲ.

*Bound.* *P*ⱼ is a multiple of 16⁻ʲ.
- If *P*ⱼ < 1/4, then √*x* − *P*ⱼ ≥ 16⁻ʲ > ρ·16⁻ʲ.
- If *P*ⱼ > 1/2, then *P*ⱼ − √*x* ≥ 16⁻ʲ > ρ·16⁻ʲ.

Both contradict convergence, so 1/4 ≤ *P*ⱼ ≤ 1/2 at every iteration:
- *P*ⱼ ∈ [1/4, 1/2): bit 57 = 0 and bit 56 = 1, so `bound_sel[6] = 1` (40–7f).
- *P*ⱼ = 1/2: bit 57 = 1 and bits 56–0 = 0, so `bound_sel = 7'h00`.

In particular the first digit is 4–8: digit 3 would give `bound_sel` = 30 and
digit 9 would give 10, and the bound excludes both. Every value loaded into
`bound_sel` is 00 or 40–7f, so the default arm is unreachable.

<a id="s6-7"></a>
## 6.7 Effective subtraction in conversions

**Items.** `fpnew_rounding` inside `fpnew_cast_multi` (CONV), sign select
`(exact_zero_o && effective_subtraction_i) ? … : sign_i`: the true arm.

**Why.** `fpnew_cast_multi` ties `effective_subtraction_i` to `1'b0`, because a
conversion performs no addition.

<a id="s6-8"></a>
## 6.8 `unit_ready` at the divider issue decisions

Unit: `fpnew_divsqrt_th_64_multi`. `unit_ready = !vfdsu_dp_fdiv_busy`. The C910
inner FSM has these states: IDLE = 0000, RF = 0100, EX1 = 0101, EX2 = 0110,
WB_REQ = 0111, WB = 1000. Busy is `state[2]`, so `unit_ready` is 1 only in IDLE
and WB.

**Items.** The `unit_ready = 0` FEC row of `in_valid_q && unit_ready`, in IDLE
and in the BUSY-completion path.

**Why.**
- **BUSY completion.** The decision is evaluated on `unit_done`, that is,
  while the inner FSM is in WB, where `unit_ready = 1`.
- **IDLE.** The outer FSM reaches IDLE in one of three ways:
  - Reset or flush, which also resets the inner FSM to IDLE at the same edge.
  - An accepted completion. This leaves the inner FSM in WB, then IDLE, unless
    a new issue moves it to RF; that issue requires the outer FSM to accept
    first, which it cannot do in IDLE without leaving IDLE.
  - In every case the inner FSM is in IDLE or WB, so `unit_ready = 1`.
- The inner flush is `flush_i | last_inp_reg_ena`, and `last_inp_reg_ena` is
  0 because `fpnew_opgroup_block` ties `reg_ena_i` to `'0`. So both FSMs see
  the same flush.

<a id="s6-9"></a>
## 6.9 C910 NaN-propagation mode tied off

**Items.** `ct_vfdsu_prepare`, both NaN-payload priority chains:
- the arms selecting an operand's sNaN/qNaN payload
  (`ex1_op*_is_*nan && vfpu_yy_xx_dqnan`), with their statements;
- their FEC rows with `vfpu_yy_xx_dqnan = 1`.

**Why.** `fpnew_divsqrt_th_64_multi` ties `vfpu_yy_xx_dqnan` to `1'b0`. RISC-V
requires the canonical NaN, so payload propagation is disabled, and only the
default canonical-qNaN arm is used.

<a id="s6-10"></a>
## 6.10 Integer destination in the DIVSQRT group

**Items.** `fpnew_opgroup_multifmt_slice` (DIVSQRT):
- `dst_fmt = dst_fmt_is_int ? int_fmt_i : dst_fmt_i`, true arm;
- `result_o = result_fmt_is_int ? ifmt_slice_result[…] : …`, true arm.

**Why.** `dst_fmt_is_int = (OpGroup == CONV) & (op_i == F2I)`, which is 0 in
the DIVSQRT group. `result_fmt_is_int` is the same flag carried through the
lane's auxiliary data.

<a id="s6-11"></a>
## 6.11 Classify result in the ADDMUL group

**Items.** `fpnew_opgroup_fmt_slice` (ADDMUL),
`result_o = result_is_class ? slice_class_result : slice_regular_result`: the
true arm.

**Why.** The ADDMUL lanes tie `lane_is_class` to `1'b0` (an FMA never
classifies), and `result_is_class` is `lane_is_class[0]`.

<a id="s6-12"></a>
## 6.12 EX1 always sees `op_sel = 1` (C910 control)

**Items.** `ct_vfdsu_ctrl`, EX1 state `if (dp_vfdsu_ex1_pipex_sel) … else div_next_state = IDLE`:
the else arm and its statement.

**Why.**
- `op_starting` issues the operation to C910. At the next edge the inner FSM
  enters RF and `func_sel` is set. At the following edge it enters EX1 and
  `op_sel` (`dp_vfdsu_ex1_pipex_sel`) is set. Both pulses self-clear one cycle
  later.
- So `op_sel = 1` in every EX1 cycle.
- A second issue cannot overlap, because the outer FSM accepts only in IDLE
  or on completion.
- A flush clears both pulses and forces the inner FSM to IDLE at the same
  edge, so the inner FSM never leaves EX1 with `op_sel = 0`.

<a id="s6-13"></a>
## 6.13 Round-robin mask index 0

Unit: `rr_arb_tree` of the four format arbiters and the top arbiter. The fair
arbiter builds its masks with the same ternaries for every index, including
`i = 0`:
`upper_mask[0] = (0 > rr_q) ? req_d[0] : 1'b0` and
`lower_mask[0] = (0 <= rr_q) ? req_d[0] : 1'b0`.

**Items.**
- `gen_mask[0]`: the true arm of the `upper_mask[0]` ternary and the false arm
  of the `lower_mask[0]` ternary.
- `lzc` of every `i_lzc_upper`: the true arm of the last-level leaf that tests
  input bit 0 (`in_tmp[0] == 1 ? …`).

**Why.** `rr_q` is unsigned, so `0 > rr_q` is always false and `0 <= rr_q` is
always true. `upper_mask[0]` is therefore always 0, and the upper LZC never
sees bit 0 set.

<a id="s6-14"></a>
## 6.14 FMA leading-zero-counter padding

**Items.** `lzc` inside each ADDMUL FMA (`i_fma/i_lzc`), internal
nodes listed below: the true arm of
`index_nodes = (sel_nodes[left] == 1) ? …`.

**Why.**
- The FMA normalisation LZC has `Width = 2·PRECISION_BITS + 3`: FP32 = 51,
  FP64 = 109, FP16 = 25.
- `lzc` builds a complete binary tree with `NumLevels = $clog2(Width)`.
  Leaves beyond `Width` are `g_out_of_range` with `sel_nodes = 0`.
- A node `(level, l)` takes its true arm only if its left child holds a live
  bit. The left child starts at input index `l · 2^(NumLevels − level)`; if
  that index is ≥ `Width`, the child holds only padding.

| Format | Width | Levels | Nodes with a dead true arm `(level, l)` |
| --- | --- | --- | --- |
| FP32 | 51 | 6 | (3,7), (4,13), (4,14), (4,15) |
| FP64 | 109 | 7 | (3,7), (4,14), (4,15), (5,28), (5,29), (5,30), (5,31) |
| FP16 | 25 | 5 | (3,7) |

Example: FP32 node (4,13) starts at 13·4 = 52 ≥ 51, while (4,12) starts at
48 < 51 and is measured.
