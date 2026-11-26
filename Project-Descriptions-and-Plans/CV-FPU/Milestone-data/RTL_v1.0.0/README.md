<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

## CV-FPU TRL-5 milestone, RTL v1.0.0

The tables and files in this directory are the TRL-5 checklist and evidence for
the OpenHW CV-FPU RTL IP. The IP reaches TRL-5 when every checklist item is
signed off or waived. Waivers and open items are recorded in the checklist.

RTL at TRL-5 is complete and functionally correct. The specification, design
and verification are consistent with each other, and the IP has been shown to
match the design intent by dynamic verification.

### IP revision

| Item | Repository | Revision |
| --- | --- | --- |
| CV-FPU RTL (fpnew) | https://github.com/openhwgroup/cvfpu | tag `v1.0.0` |
| CVA6 FPU wrapper (`fpu_wrap`) | https://github.com/openhwgroup/cva6 (main) | `715ca95` |
| Verification environment | https://github.com/openhwgroup/cvfpu-uvm | tag `v1.0.0` |

Dependencies of the RTL under test:

| Component | Repository | Revision |
| --- | --- | --- |
| common_cells | https://github.com/pulp-platform/common_cells | tag `v1.40.0` |
| tech_cells_generic | https://github.com/pulp-platform/tech_cells_generic | tag `v0.2.14` |
| common_verification | https://github.com/pulp-platform/common_verification | tag `v0.2.5` |

The vendored divider RTL (T-Head C910 `ct_vfdsu_*`) is
part of the cvfpu repository.

### Deliverables

Open-source collateral:
- User manual: the `docs/` folder of the cvfpu repository.
- RTL source code: cvfpu and `fpu_wrap.sv` (CVA6 wrapper of the CVFPU).
- Verification plan and reports: this directory.
- Verification environment (UVM testbench) source code: cvfpu-uvm.

### Scope of verification

**Design under test.** `fpu_wrap`, the CVA6 wrapper of the FPU, and
everything below it: `fpnew_top` with all operation groups (ADDMUL, DIVSQRT,
NONCOMP, CONV) and the vendored C910 divide/square-root unit. The testbench
drives `fpu_wrap` directly through its CVA6 functional-unit interface (no
CVA6 core). Results are checked against a C++ reference model built on GNU MPFR,
which is called through DPI. From CVA6, only `fpu_wrap` is part of this
release. The CVA6 packages are compiled only to build it, and this release does
not cover them.

**Configuration.** CVA6 `cv64a60ax`. `fpu_wrap` instantiates `fpnew_top` and
derives its parameters from the CVA6 configuration:

| CVA6 field | Value | Effect on the FPU |
| --- | --- | --- |
| `XLEN` | 64 | INT32 and INT64 conversions |
| `RVF`, `RVD` | 1, 1 | FP32 and FP64 (RISC-V F and D), `FLen = 64` |
| `XF16` | 1 | FP16 (IEEE binary16, RISC-V Zfh) |
| `XF16ALT`, `XF8` | 0, 0 | FP16ALT and FP8 disabled |
| `XFVec` | 0 | Scalar only, no SIMD |
| `NrScoreboardEntries` | 8 | `TRANS_ID_BITS = 3`, operation tag `logic [2:0]` |

Resulting `fpnew_top` parameters:

| Parameter | Value |
| --- | --- |
| `Features.Width` | 64 |
| `Features.EnableVectors` | 0 (one lane, `simd_mask_i` tied to 1) |
| `Features.EnableNanBox` | 1 |
| `Features.FpFmtMask` | `5'b11100`: FP32, FP64, FP16 on; FP8, FP16ALT off |
| `Features.IntFmtMask` | `4'b0011`: INT32, INT64 on; INT8, INT16 off |
| `DivSqrtSel` | `THMULTI` (C910 multi-format divide/square root) |
| `TrueSIMDClass`, `EnableSIMDMask` | 0, 0 |
| `PipeRegs` | ADDMUL FP32/FP64/FP16 = 2/3/1; DIVSQRT 2; NONCOMP 1; CONV 2 |
| `UnitTypes` | ADDMUL, NONCOMP `PARALLEL`; DIVSQRT, CONV `MERGED` |
| `PipeConfig` | `DISTRIBUTED` |

The mask bits are in `fp_format_e` order (FP32, FP64, FP16, FP8, FP16ALT) and
`int_format_e` order (INT8, INT16, INT32, INT64), MSB first. `PipeRegs` and
`UnitTypes` also have entries for FP8 and FP16ALT, but no hardware is
generated for them because their `FpFmtMask` bit is 0. `fpu_wrap` ties the FPU
output ready to 1.

**Operations.** All operations of the RISC-V F, D and Zfh extensions (Zfh is
enabled in CVA6 by `XF16`): add, sub, mul, fused multiply-add (4 variants), div, sqrt, min/max,
sign injection, compare, classify, FP–FP conversions, FP–integer conversions in
both directions (32- and 64-bit, signed and unsigned), and moves. Rounding modes
RNE, RTZ, RDN, RUP and DYN; flush and reset during operation; input
back-pressure at the FPU boundary.

**Out of scope** (disabled in this configuration, or not in the RISC-V
encoding): FP8, FP16ALT, SIMD/vectorial operations, INT8/INT16 conversions,
ROD rounding.

**Known limitation.** RMM rounding is legal and implemented but not verified,
because the MPFR-based reference model cannot round ties away from zero. See
[`Waivers/README.md`](Waivers/README.md).

**Coverage scope.** Code coverage is measured on `/top/dut` and below, with
statement, branch, condition, expression and FSM metrics. Expression coverage
is Questa's focused expression coverage (FEC) of the right-hand side of
assignments. Toggle coverage and the testbench code are not TRL-5 metrics. Functional coverage is measured
with covergroups and cover directives. Assertions are checkers: they are
counted by failures, not as coverage.

### Tools

| Tool | Version | Use |
| --- | --- | --- |
| Siemens Questa | Sim-64 vsim 2025.3_2 (2025.11) | Simulation, coverage, waivers, reports (sign-off simulator) |
| Verilator | 5.048 | RTL lint |
| Bender | 0.29.1 | Dependency management |
| GNU MPFR / GMP | 4.2.2 / 6.3.0 | Reference model |

### Results

Regression (`simu/fpu_reg_list`): 11 tests, 186 runs, **186 pass, 0 fail**. Per-test results are in
[`Reports/Simulation/`](Reports/Simulation/README.md).

**Code coverage**, `/top/dut`, merged over the 186 runs:

| Metric | Bins | Pre-waiver hits | Pre-waiver | Waived | Post-waiver |
| --- | ---: | ---: | ---: | ---: | ---: |
| Statement | 5404 | 5294 | 97.96% | 110 | **100.00%** |
| Branch | 3371 | 3170 | 94.03% | 201 | **100.00%** |
| Condition | 167 | 133 | 79.64% | 41 FEC rows | **100.00%** |
| Expression | 2223 | 1849 | 83.17% | 374 terms (487 FEC rows) | **100.00%** |
| FSM state | 9 | 8 | 88.88% | 1 | **100.00%** |
| FSM transition | 16 | 13 | 81.25% | 3 | **100.00%** |

Questa counts expression bins per input term. After the waivers it reports
2111 of 2111 expression bins: a term whose missing rows are excluded counts as
covered, and a term with every row excluded is removed from the total.

The 843 waived items (356 statement, branch, condition and FSM items, plus
487 expression FEC rows), by category:

| Category | S / B / C / FSM | Expression rows |
| --- | ---: | ---: |
| 1 rounding modes | 36 | 32 |
| 2 vector operations | 126 | 43 |
| 3 FP8/FP16ALT | 31 | 89 |
| 4 MERGED units | 28 | 152 |
| 5 `fpu_out_ready` | 25 | 7 |
| 6 structurally unreachable | 110 | 164 |

See [`Waivers/README.md`](Waivers/README.md).

**Functional coverage**, merged over the 186 runs:

| Item | Total | Hit | Coverage |
| --- | ---: | ---: | ---: |
| Covergroups (17) — bins | 8480 | 8480 | 100.00% |
| Cover directives | 66 | 66 | 100.00% |

**Assertions** (checkers): 67, with 0 failures over the 186 runs. 43 are
concurrent assertions, and each one passed at least once with its condition
true. The other 24 are parameter checks done once at startup (`ASSERT_INIT`).

RTL lint: Verilator 5.048 `-Wall` gives no errors and 494 warnings, all waived
in [`Reports/Lint/README.md`](Reports/Lint/README.md).

### Contents

| File | Content |
| --- | --- |
| [`OpenHWFdn_TRL5_CVFPU_Checklist.xlsx`](OpenHWFdn_TRL5_CVFPU_Checklist.xlsx) | Completed checklist, one tab per category; the same tables are in [`OpenHWFdn_TRL5_CVFPU_Checklist/`](OpenHWFdn_TRL5_CVFPU_Checklist/) as CSV. |
| [`Testplan/`](Testplan/) | Verification plan: `cvfpu_uvm_testplan.xlsx` and one CSV per tab (ARITH, COMP_MOVE, CONV, TESTS). Every item maps to a test, covergroup, assertion or cover property. |
| [`Waivers/`](Waivers/) | `exclude.do`, how it is organised and applied ([`Waivers/README.md`](Waivers/README.md)), and one proof file per waiver category. |
| [`CVFPU_waiver_list.xlsx`](CVFPU_waiver_list.xlsx) | Every waived code coverage item, with its `exclude.do` command and proof link; post-waiver coverage summary. |
| [`CVFPU_Design_Issue_Summary.xlsx`](CVFPU_Design_Issue_Summary.xlsx) | GitHub issues of openhwgroup/cvfpu at release time, with their `DoesNotGate_v1.0.0` status. |
| [`Reports/Coverage/`](Reports/Coverage/README.md) | Questa coverage reports in HTML and text: `code_cov/` (DUT statement, branch, condition, expression and FSM coverage after waivers, with excluded items shown) and `funct_cov/` (covergroups and cover directives, plus assertion failure and pass counts). |
| [`Reports/Simulation/`](Reports/Simulation/) | Regression list and per-test results. |
| [`Reports/Lint/`](Reports/Lint/README.md) | RTL lint log and the waiver reason for each warning class. The lint wrapper and file list are in `lint/` of cvfpu-uvm. |
