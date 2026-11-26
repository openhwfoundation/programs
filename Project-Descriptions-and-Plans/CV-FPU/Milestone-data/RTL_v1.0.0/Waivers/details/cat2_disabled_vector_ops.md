<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# [Category 2] FPU config: vector operations are disabled

The CVA6 configuration has `XFVec = 0`. In `fpu_wrap`:

- `FPU_FEATURES.EnableVectors = CVA6Cfg.XFVec = 0`.
- `fpu_vec_op_d = CVA6Cfg.XFVec && (fu == FPU_VEC)` is the constant 0. Every
  `vectorial_op_i` that fpnew receives is therefore 0.
- The decoder never issues the `VF*` operations. The stimulus mirrors this:
  `fpu_txn` restricts `m_operation` to the scalar range `FADD`..`FCLASS`.

From these facts, every path that needs a vectorial operation, or a
vectorial-only operation, is dead.

<a id="s2-1"></a>
## 2.1 Vector decode, operand replication and vector-only branches

**Items.**
- `fpu_wrap`:
  - `if (fpu_vec_op_d) fpu_rm_d = fpu_frm_i`;
  - the vectorial alternative of the `fmt = 01` format decode;
  - the `VF*` arms of the operation case (VFMIN, VFMAX, VFSGNJ*, VFEQ/NE/LT/GE/LE/GT, VFCPKAB/CD and their statements);
  - the replication block `if (fpu_vec_op_d && vec_replication)` with its per-format case arms and statements, and its FEC rows.
- `fpnew_divsqrt_th_64_multi`: `inp_pipe_ready = result_vec_op_q ? simd_synch_rdy_i : in_ready`, true arm.
- `fpnew_opgroup_fmt_slice`: `result_is_vector ? slice_vec_class_result : …`, true arm.
- `fpnew_opgroup_multifmt_slice` (CONV group):
  - `conv_target_d = dst_is_cpk ? operands_i[2] : …`, true arm;
  - the vectorial F2F up-cast operand select (`vectorial_op && op_mod_i && is_up_cast`) and its statement;
  - the CPK operand override, with their FEC rows;
  - expression `dst_is_cpk = … (op_i == CPKAB || op_i == CPKCD)`: the FEC
    rows with either compare true.

**Why.**
- Each branch is guarded by `fpu_vec_op_d`, `vectorial_op` or
  `result_vec_op_q`, all constant 0, or it decodes a `VF*` operation that is
  never issued.
- CPK (convert-and-pack) exists only as a vector operation, so `dst_is_cpk` is
  0 as well.

<a id="s2-2"></a>
## 2.2 `fpu_vec_op_d` in the AH check

**Items.** `fpu_wrap`, condition `!fpu_vec_op_d && check_ah`: the FEC row with
`fpu_vec_op_d = 1`.

**Why.** `fpu_vec_op_d` is the constant 0 (see above). Only that row is waived;
the `check_ah` rows are covered.

<a id="s2-3"></a>
## 2.3 Vector bypass pipeline of the CONV slice

**Items.** `fpnew_opgroup_multifmt_slice` (CONV), `target_regs`, both
`gen_bypass_pipeline` stages: the load arm of the `byp_pipe_target_q` and
`byp_pipe_aux_q` enable registers, with their statements.

Expression rows, same unit and stages:
- `byp_pipe_valid_q[0] = in_valid_i & vectorial_op`: the rows that need
  `vectorial_op = 1`;
- `byp_pipe_ready[i] = byp_pipe_ready[i+1] | ~byp_pipe_valid_q[i+1]`: the rows
  that need a valid token in the next stage;
- `reg_ena`: the rows that need a valid token or `reg_ena_i = 1`;
- `byp_pipe_ready[NumPipeRegs] = out_ready_i & result_is_vector`: the rows
  that need `result_is_vector = 1`.

**Why.** The registers load on
`reg_ena = (byp_pipe_ready & byp_pipe_valid_q) | reg_ena_i`:
- `byp_pipe_valid_q[0] = in_valid_i & vectorial_op`, which is 0, so no valid
  token ever enters the bypass pipeline.
- `fpnew_opgroup_block` ties `reg_ena_i` to `'0`.

So `reg_ena` is constantly 0. `result_is_vector` is the vectorial flag
carried with the operation, so it is 0 as well, and no `byp_pipe_valid_q`
stage is ever 1.

<a id="s2-4"></a>
## 2.4 NaN-box check bypass

**Items.** `fpnew_top`, `is_boxed = !vectorial_op_i ? (upper bits == '1) : 1'b1`:
the vectorial arm, for every narrower format and operand.

**Why.** `vectorial_op_i` is the constant 0, so NaN boxing is always checked.

<a id="s2-5"></a>
## 2.5 SIMD lane synchronisation in the divider

Unit: `fpnew_divsqrt_th_64_multi`. `result_vec_op_q` is loaded from the
vectorial flag of the issued operation, so it is always 0. Hence:

- `simd_synch_done = simd_synch_done_i || ~result_vec_op_q` is constantly 1.
- `unit_done_clear = simd_synch_done | last_inp_reg_ena | flush_i` is
  constantly 1.

**Items and reasons.**
- **`unit_done_q` load arm** (`FFLARNC(unit_done_q, unit_done, unit_done, unit_done_clear, …)`).
  The clear has priority over the load and is always asserted, so
  `unit_done_q` stays 0.
- **Held-result select**, `result_d`/`status_d = unit_done_q ? held_* : unit_*`,
  true arms: `unit_done_q` is always 0.
- **BUSY completion condition** `simd_synch_done_i || (~result_vec_op_q && unit_done)`:
  the rows with `simd_synch_done_i = 1` and with `result_vec_op_q = 1`.
  `simd_synch_done_i` is the AND of the lanes' `divsqrt_done_o =
  (unit_done_q | unit_done) & result_vec_op_q`, which is 0.
- **Per-lane NaN-boxed operands**, `dp_vfdsu_ex1_pipex_srcf0/1 =
  result_vec_op_q ? srcf*_boxed : {…, srcf*_q}`, true arms: only a vectorial
  operation selects the per-lane boxed operands, and `result_vec_op_q` is
  always 0. Scalar operands reach the C910 unchanged, so an operand that is
  not NaN-boxed is still treated as a NaN.
- **Expression rows.**
  - `simd_synch_done = simd_synch_done_i || ~result_vec_op_q`: the rows with
    `simd_synch_done_i` = 0 or 1 under `result_vec_op_q = 1`, and
    `result_vec_op_q = 1`.
  - `unit_done_clear = simd_synch_done | last_inp_reg_ena | flush_i`: the
    `simd_synch_done = 0` row, and the `last_inp_reg_ena` and `flush_i` rows,
    which are observable only while `simd_synch_done = 0`.
  - `divsqrt_done_o = (unit_done_q | unit_done) & result_vec_op_q`: the rows
    that need `result_vec_op_q = 1`.
  - `inp_pipe_ready = result_vec_op_q ? simd_synch_rdy_i : in_ready`: the
    `result_vec_op_q = 1` row and both `simd_synch_rdy_i` rows.

<a id="s2-6"></a>
## 2.6 Vector-op hold select in `fpu_wrap`

**Items.** `fpu_wrap`, expression
`fpu_vec_op = use_hold ? fpu_vec_op_q : fpu_vec_op_d`:
- the `_1` rows of `fpu_vec_op_q` and `fpu_vec_op_d`;
- the output-1 column of both `use_hold` rows (`-col 1`).

**Why.** `fpu_vec_op_d = CVA6Cfg.XFVec && …` is the constant 0, and
`fpu_vec_op_q` only loads `fpu_vec_op_d`. Both data inputs are 0, so the
output is the constant 0. Both `use_hold` rows hit only with output 0 (186 and
144 runs), and Questa needs a hit with output 1 to show that `use_hold`
controls the output. Only the output-1 column is waived, so the output-0 hits
stay in the report.
