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
