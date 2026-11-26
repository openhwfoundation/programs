<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# [Category 3] FPU config: FP8 and FP16ALT formats are disabled

The CVA6 configuration has `XF8 = 0` and `XF16ALT = 0`. Effects:

- `fpu_wrap` sets `FpFmtMask = {RVF, RVD, XF16, XF8, XF16ALT} = 5'b11100`, in
  fpnew format order FP32, FP64, FP16, FP8, FP16ALT.
- The CVA6 decoder rejects every FP8/FP16ALT encoding as illegal:
  - the F2F source format `rs2[22:20]` is legal only as 000 (RVF),
    001 (RVD) or 010 (XF16); 110 (FP16ALT), 011 (FP8) and every other value
    are illegal;
  - min/max, sign injection, compare and classify encode the operation in
    `rm`, which must be 000–010; the FP16ALT variants 100–110 are legal only
    with `XF16ALT = 1`.
- The stimulus mirrors the decoder:
  - `m_fmt` ∈ {0, 1, 2} (FP32, FP64, FP16);
  - F2F `m_imm` ∈ {0, 1, 2};
  - `rm` never has bit 2 set for rm-encoded operations (category 1).

<a id="s3-1"></a>
## 3.1 Format decode in `fpu_wrap`

**Items.**
- Scalar F2F source-format case `unique case (operand_c_i[2:0])`: the
  `3'b110` (FP16ALT) and `3'b011` (FP8) arms, and the `default` arm.
- AH encoding fix-up `if (ah_bit) fpu_dstfmt_d = fpnew_pkg::FP16ALT`: the true
  arm and its statement.

**Why.**
- `operand_c_i[2:0]` carries the decoded `rs2[22:20]`, which is 000, 001 or
  010 for every legal instruction.
- `ah_bit` is `rm[2]`, or `frm[2]` when `rm = 111`. The operations that set
  `check_ah` accept only `rm` 000–010, so `rm[2] = 0`, and `rm = 111` is
  illegal for them.

<a id="s3-2"></a>
## 3.2 FP16ALT in the divider format translation

**Items.** `fpnew_divsqrt_th_64_multi`, `translate_fmt`: the
`fpnew_pkg::FP16ALT` arm and its statement.

**Why.** `dst_fmt_q` is the destination format of an issued DIV or SQRT, so
it is FP32, FP64 or FP16.

<a id="s3-3"></a>
## 3.3 Round-robin state of the format arbiters

Unit: `rr_arb_tree` inside each operation group's format arbiter
(`NumIn = 5`; index FP32=0, FP64=1, FP16=2, FP8=3, FP16ALT=4).

- `req[3]` (FP8) and `req[4]` (FP16ALT) are always 0.
- `rr_q` resets to 0 and only ever loads the index of a granted request, so
  `rr_q ∈ {0, 1, 2}`.

**Items and reasons.**
- **Mask ternaries for i = 3 and 4** (`gen_mask[i]`): the false arm of
  `upper_mask[i] = (i > rr_q) ? …` and the true arm of
  `lower_mask[i] = (i <= rr_q) ? …`. Since `rr_q ≤ 2 < i`, `i > rr_q` is always
  true. Waived here for the PARALLEL groups (ADDMUL, NONCOMP); for the MERGED
  groups see 4.1.
- **Tree node (level 1, l = 1)** in every group (`gen_other_levels`): the
  false arms of `index_nodes = (sel) ? …` and `data_nodes = (sel) ? …`. Its
  children are the leaf for {FP16ALT, padding} and an all-padding leaf, so both
  `req_nodes` are 0 and `sel = ~req_nodes[left] | …` is constantly 1.
- **LZC node (level 1, l = 1)** of both `i_lzc_upper` and `i_lzc_lower`, in
  every group: the true arm of
  `index_nodes = (sel_nodes[left] == 1) ? …`. With `NumIn = 5` the tree has
  3 levels. The tested left child is the single-bit leaf for input bit 4 (the
  FP16ALT request, always 0), so its `sel_nodes` is 0.

<a id="s3-4"></a>
## 3.4 FP8/FP16ALT slots of the ADDMUL and NONCOMP format arbiters

Unit: `rr_arb_tree` of the ADDMUL and NONCOMP format arbiters, and the
`i_lzc_upper`/`i_lzc_lower` of their fair arbiters. With `NumIn = 5` the tree
is padded to 8 leaves:

| Tree node | Inputs | Value |
| --- | --- | --- |
| leaf (2,1) | `req[2]`, `req[3]` | `req[3] = 0` |
| leaf (2,2) = node 5 | `req[4]` | 0 |
| leaf (2,3) = node 6 | padding | 0 |
| node (1,1) = node 2 | nodes 5 and 6 | 0 |

**Items.** Expression FEC rows:
- `gen_mask[3]`, `gen_mask[4]`: the mask ternaries' condition rows and the
  `req_d[i] = 1` row;
- leaf (2,1): `req_d[2] | req_d[3]` with `req_d[3] = 1`, and in
  `sel = ~req_d[2] | req_d[3] & rr_q[0]` the `req_d[3] = 1` row and both
  `rr_q[0]` rows;
- root (0,0) and node (1,1): `req_nodes` OR rows with node 2, 5 or 6 = 1; in
  their `sel` expressions the rows with those nodes = 1, both `rr_q` rows and,
  at the root, the `req_nodes[2] = 0` row that needs `rr_q[2] = 1`;
- node (1,1) grant split `gnt_nodes[2] & ~sel`, `gnt_nodes[2] & sel`: the
  `sel = 0` rows and the `gnt_nodes[2]` rows under `~sel`;
- both LZCs: the `_1` rows of `in_tmp[3]` (leaf (2,1)) and of the node 2, 5
  and 6 inputs at the root and at node (1,1).

**Why.** `req[3] = req[4] = 0`, and `rr_q ∈ {0, 1, 2}` (3.3), so `rr_q[2] = 0`.
Node 6 is padding and node 5 is `req[4]`, so node 2 is always 0 and its `sel`
is constantly 1. Every row above needs one of these signals at the other
value, or is observable only when one of them is. The `rr_q` rows of an `sel`
expression are observable only when the right child requests.

<a id="s3-5"></a>
## 3.5 FP16ALT (bfloat) arms of the C910 format selects

**Items.** The last (bfloat) arm of the four-way format selects
`double ? … : single ? … : half ? … : bfloat`: the FEC row of the bfloat term
with the value it never takes (`_1`, or `_0` for `ex3_bfloat_denorm_zero`), in
- `ct_vfdsu_ctrl`: `srt_secd_round_pre` (`srt_cnt == 2`);
- `ct_vfdsu_srt`: `ex2_potnt_of_pre`, `ex2_potnt_uf_pre`;
- `ct_vfdsu_round`: `ex3_denorm_potnt_norm`, `ex3_denorm_plus`,
  `ex3_denorm_eq`, `ex3_denorm_gr`, `ex3_denorm_zero`, `ex3_denorm_lst_frac`.

**Why.** The bfloat arm is selected when the stage's `double`, `single` and
`half` flags are all 0. These flags come from the one-hot `divsqrt_fmt` (6.2);
the bfloat encoding needs an FP16ALT divide or square root, which never reaches
the divider (3.2). The flags are registers that reset to 0 and are reloaded
with a one-hot value by every operation, so they are all 0 only between a
reset and the first operation that reaches the stage. The datapath of the stage
then holds its reset value: `srt_cnt = 0`, exponent 0 and quotient 0. The
bfloat terms are therefore seen only at their reset value (0, and 1 for
`ex3_bfloat_denorm_zero`).
