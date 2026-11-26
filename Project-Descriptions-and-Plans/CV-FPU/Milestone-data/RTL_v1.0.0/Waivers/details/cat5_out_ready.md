<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# [Category 5] `fpu_wrap` ties `fpu_out_ready` to 1

`fpu_wrap` drives `fpnew_top.out_ready_i` with `fpu_out_ready = 1'b1`. CVA6
has a dedicated FPU write-back port, so a result is never back-pressured.

<a id="s5-1"></a>
## 5.1 Top-level arbiter grant

**Items.** `rr_arb_tree` of `fpnew_top`
(`i_arbiter/…/gen_fair_arb`), condition `rr_d = (gnt_i && req_o) ? …`: the
FEC row with `gnt_i = 0`.

Expression rows: the root grant split of the same arbiter,
`gnt_nodes[1] = gnt_nodes[0] & ~sel` and `gnt_nodes[2] = gnt_nodes[0] & sel`:
the row with `gnt_nodes[0] = 0`.

**Why.** This arbiter's `gnt_i` is `fpnew_top.out_ready_i`, which is the
constant 1, and `gnt_nodes[0] = gnt_i`. The format arbiters inside the operation groups do see
`gnt_i = 0`, so this row is waived for the top arbiter only.

<a id="s5-2"></a>
## 5.2 Divider HOLD state

Unit: `fpnew_divsqrt_th_64_multi` (THMULTI, C910 divider). The outer FSM enters
HOLD only when the inner unit completes while the output buffer cannot take
the result: BUSY with `unit_done && !out_ready`.

**Items.**
- FSM state HOLD and its transitions BUSY→HOLD, HOLD→IDLE and HOLD→BUSY.
- The BUSY `else` arm (`state_d = HOLD`).
- The HOLD case arm, and the branches, statements and FEC rows inside it.

**Why `out_ready` is never low at completion.**
1. **One output register.** `LAT_DIVSQRT = 2` with
   `PipeConfig = DISTRIBUTED` gives `NUM_OUT_REGS = 1`. `out_ready` is low only
   while a previous result sits ungranted in that register.
2. **The register drains within 4 cycles.**
   - The result first passes the DIVSQRT format arbiter. It has a single live
     request (category 4), and its `gnt_i` comes from the top arbiter.
   - The top arbiter has 4 operation-group inputs, `FairArb = 1`,
     `LockIn = 0` and `gnt_i = out_ready_i = 1` (5.1).
   - A pending request is therefore granted within 4 cycles.
3. **Completions are at least 5 cycles apart.** The C910 controller
   (`ct_vfdsu_ctrl`) signals completion in state WB. The shortest path from one
   WB to the next is WB → RF → EX1 → EX2 → WB_REQ → WB: 5 edges, even with a
   single SRT round.

Since 4 < 5, the previous result has left the register before the next
completion. A flush or reset clears the register rather than stalling it.
This holds only while `fpu_out_ready` is 1: if CVA6 ever back-pressured the
FPU, HOLD would become reachable.

<a id="s5-3"></a>
## 5.3 Hold-register enable

**Items.**
- `fpnew_divsqrt_th_64_multi`, the load arms of the `held_result_q` and
  `held_status_q` registers (`FFLNR(…, hold_en, …)`) and their statements.
- Expression rows of `hold_en`: `unit_done = 1` and `out_ready = 0` under the
  stall condition, both `simd_synch_done_i` rows, and `result_vec_op_q = 1`.

**Why.**
`hold_en = unit_done & (~simd_synch_done_i | ~out_ready) & ~(~result_vec_op_q & out_ready)`.
- In scalar mode `result_vec_op_q = 0` (category 2), so this reduces to
  `unit_done & ~out_ready`.
- That is the stall condition that 5.2 shows cannot occur. The
  `simd_synch_done_i` and `result_vec_op_q` rows need a vectorial operation.
