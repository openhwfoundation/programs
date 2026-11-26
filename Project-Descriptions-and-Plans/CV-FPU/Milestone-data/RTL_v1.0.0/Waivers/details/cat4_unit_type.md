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

`rr_arb_tree` tree nodes of `NumIn = 5` (padded to 8 leaves):

| Tree node | Inputs |
| --- | --- |
| leaf (2,0) = node 3 | `req[0]`, `req[1]` |
| leaf (2,1) = node 4 | `req[2]`, `req[3]` |
| leaf (2,2) = node 5 | `req[4]` |
| leaf (2,3) = node 6 | padding |
| node (1,0) = node 1 | nodes 3 and 4 |
| node (1,1) = node 2 | nodes 5 and 6 |

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

<a id="s4-6"></a>
## 4.6 Idle slots of the DIVSQRT and CONV format arbiters

**Items.** Expression FEC rows of the DIVSQRT and CONV format arbiters:
- `gen_mask[1..4]`: the mask ternaries' condition rows and the `req_d[i] = 1`
  row;
- leaves (2,0) and (2,1): the `req_d[1..3] = 1` rows of `req_d[l*2] | req_d[l*2+1]`;
  in `sel` the rows with `req_d[1..3] = 1` and both `rr_q[0]` rows; at leaf
  (2,1) the grant split `gnt_nodes[4] & ~sel` / `& sel`: the `sel = 0` rows
  and the `gnt_nodes[4]` rows under `~sel`;
- the root and nodes (1,0), (1,1): the `req_nodes` rows with node 2, 4, 5 or 6
  = 1, their `sel` rows and both `rr_q` rows, and the grant split of node (1,1);
- `i_lzc_lower` and `i_lzc_upper`: the `_1` rows of every leaf input and child
  node that holds only indices 1–4 or padding.

**Why.** Only `req[0]` is live, and `rr_q = 0` forever (see the introduction).
Every row above needs a request at index 1–4, a non-zero `rr_q` bit, or a
right child that requests. The `i_lzc_upper` rows whose only live input is
bit 0 are waived in 6.13, because `upper_mask[0]` is always 0.

<a id="s4-7"></a>
## 4.7 MERGED unit-type check on the slice input valid

**Items.** `fpnew_opgroup_block` of DIVSQRT and CONV,
`in_valid = in_valid_i & (FmtUnitTypes[dst_fmt_i] == MERGED)`: the FEC row with
the compare at 0.

**Why.** In these two groups every format's unit type is MERGED (see the
table above), so the compare is the constant 1. The PARALLEL groups have no
merged slice, so the expression exists only in DIVSQRT and CONV.
