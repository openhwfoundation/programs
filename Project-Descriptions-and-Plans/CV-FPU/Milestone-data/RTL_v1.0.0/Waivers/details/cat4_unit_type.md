<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# [Category 4] FPU config: DIVSQRT and CONV use MERGED units

`fpu_wrap` sets these `UnitTypes`:

| Group | Unit type |
| --- | --- |
| ADDMUL | PARALLEL |
| DIVSQRT | MERGED |
| NONCOMP | PARALLEL |
| CONV | MERGED |

In a MERGED group, one multi-format slice serves every format.
`fpnew_opgroup_block` routes its output through format index 0 (FP32), and its
`merged_unused` branch ties `fmt_out_valid = 0` for every other format. As a
result, the format arbiter of DIVSQRT and CONV sees:

- `req[0]` live and `req[1..4] = 0`;
- `rr_q = 0` forever, because only index 0 is ever granted;
- `upper_mask` all 0: `upper_mask[0]` is always 0 (see 6.13), and the other bits
  have no request.

In the PARALLEL groups, FP64 and FP16 raise real requests, so none of this
applies there.

<a id="s4-1"></a>
## 4.1 Format-arbiter masks and next index (DIVSQRT, CONV)

**Items.** `rr_arb_tree` of the DIVSQRT and CONV format arbiters:
- for i = 1..4, the false arm of `upper_mask[i] = (i > rr_q) ? …` and the true
  arm of `lower_mask[i] = (i <= rr_q) ? …`;
- the `upper_idx` arm of `next_idx = upper_empty ? lower_idx : upper_idx`.

**Why.**
- `rr_q = 0` makes `i > rr_q` true for every i ≥ 1, so the masks' other arms
  are never taken.
- The upper mask is all 0, so `upper_empty = 1`.

<a id="s4-2"></a>
## 4.2 Leaf select for indices 2/3 (DIVSQRT, CONV)

**Items.** `rr_arb_tree`, leaf `l = 1` (indices 2 and 3): the false arm of
`data_nodes = (sel) ? data_i[3] : data_i[2]`.

**Why.** `req[2] = req[3] = 0`, so `sel = ~req[2] | req[3] & rr_q[…]` is
constantly 1.

<a id="s4-3"></a>
## 4.3 FP16 leaf of the LZCs (DIVSQRT, CONV)

**Items.** `lzc` of `i_lzc_upper` and `i_lzc_lower`, last-level leaf testing
bit 2: the true arm of `index_nodes = (in_tmp[2] == 1) ? …`.

**Why.** Both mask bit 2 values derive from `req[2]` (FP16), which is tied to 0
in a MERGED group.

<a id="s4-4"></a>
## 4.4 Upper-LZC internal node over bits 0–1 (DIVSQRT, CONV)

**Items.** `lzc` of `i_lzc_upper`, node `(level 1, l = 0)`: the true arm of
`index_nodes = (sel_nodes[left] == 1) ? …`.

**Why.** The left child is the leaf for mask bits 0 and 1:
- bit 0 is `upper_mask[0]`, which is always 0 (see 6.13);
- bit 1 is 0 because `req[1] = 0` in a MERGED group.

So `sel_nodes[left]` is constantly 0. In PARALLEL groups bit 1 (FP64) is live,
and this arm is measured there.

<a id="s4-5"></a>
## 4.5 Upper-LZC root (DIVSQRT, CONV)

**Items.** `lzc` of `i_lzc_upper`, root node `(level 0, l = 0)`: the true
arm of `index_nodes = (sel_nodes[left] == 1) ? …`.

**Why.** The left child covers mask bits 0–3, all of which are 0 in the upper
mask of a MERGED group (see the introduction). So `sel_nodes[left]` is
constantly 0.
