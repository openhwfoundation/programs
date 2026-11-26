<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# [Category 1] Undriven rounding modes: RMM/ROD

The RISC-V `rm` field encodes RNE=000, RTZ=001, RDN=010, RUP=011,
RMM=100 and DYN=111; 101 and 110 are reserved. fpnew additionally defines
ROD=101 (round to odd), which has no scalar RISC-V encoding.

What reaches the FPU:

- **CVA6 decoder.** `rm` = 101 is legal only as the FP16ALT encoding
  (`XF16ALT = 1`), and 110 is always illegal. With DYN, `frm` must be 000–100.
  `fpu_wrap` resolves DYN to `frm` before issue, so the arithmetic units receive
  000–100 only.
- **Stimulus.** The UVM agent drives `fpu_wrap` directly and mirrors the decoder
  rules, but it also excludes RMM, because the MPFR-based reference model
  cannot compute round-to-nearest-ties-away (RMM) results.

The units therefore see only RNE, RTZ, RDN and RUP.

<a id="s1-1"></a>
## 1.1 RMM not stimulated

**Items.**
- `fpnew_rounding`: the `RMM` case arm, in every instance.
- `ct_vfdsu_prepare`: the `3'b100` arm of the overflow-to-LFN case.
- `ct_vfdsu_round`: the `3'b100` arm of the rounding case, with its statements
  and the denormal-select ternaries inside it.
- Expression rows: every FEC row of the three ternaries in that arm
  (`frac_add_1`, `frac_orig` and `denorm_to_tiny_frac`).

**Why.** These arms decode `rm = 100`, which is legal and reachable in the
design. They stay uncovered only because the stimulus never issues RMM (see
above).

<a id="s1-2"></a>
## 1.2 ROD has no scalar encoding

**Items.**
- `fpnew_rounding`: the `ROD` case arm, in every instance.
- Expression rows: the four FEC rows of
  `round_up = ~abs_value_i[0] & (| round_sticky_bits_i)` in that arm, in every
  instance (`# 1.2` in `exclude.do`).

**Why.** ROD is fpnew's `3'b101`. On the scalar path, 101 is either illegal or
(with `XF16ALT = 1`) re-interpreted by `fpu_wrap` as an FP16ALT format select
and replaced by `frm`. It never reaches `rnd_mode_i` as a rounding mode.

<a id="s1-3"></a>
## 1.3 Reserved encodings in the C910 divider

**Items.** The `default` arms of the rounding-mode case in `ct_vfdsu_prepare`
(overflow-to-LFN) and `ct_vfdsu_round` (round increment), with their
statements.

**Why.** The default arm is taken for `rm` ∈ {101, 110, 111}. As shown above,
the divider receives `rm` ≤ 100 (≤ 011 in this stimulus): 101 is ROD/reserved,
110 is reserved, and 111 (DYN) is resolved by `fpu_wrap` before it reaches the
divider.
