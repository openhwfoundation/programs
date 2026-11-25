<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# CV-FPU v1.0.0 — simulation regression

Regression: Questa Sim-64 2025.3_2, coverage enabled, the
cvfpu-uvm regression list `simu/fpu_reg_list` with one random seed per run.
`regression_results.csv` lists every test, seed and result.

| Test | Runs in list | Run | Pass | Fail |
| --- | ---: | ---: | ---: | ---: |
| `fpu_single_op_test` | 10 | 10 | 10 | 0 |
| `fpu_random_test` | 20 | 20 | 20 | 0 |
| `fpu_op_group_test` | 15 | 15 | 15 | 0 |
| `fpu_fmt_single_op_test` | 20 | 20 | 20 | 0 |
| `fpu_fmt_random_test` | 20 | 20 | 20 | 0 |
| `fpu_fmt_op_group_test` | 20 | 20 | 20 | 0 |
| `fpu_conv_test` | 10 | 10 | 10 | 0 |
| `fpu_special_val_test` | 20 | 20 | 20 | 0 |
| `fpu_random_op_bp_test` | 25 | 25 | 25 | 0 |
| `fpu_op_group_bp_test` | 25 | 25 | 25 | 0 |
| `fpu_pipeline_stress_test` | 1 | 1 | 1 | 0 |
| **Total** | **186** | **186** | **186** | **0** |

A run passes when its log shows the UVM report summary with UVM_ERROR = 0 and
UVM_FATAL = 0, Questa reports `Errors: 0`, and the coverage database (UCDB) is
saved. The scoreboard compares every FPU result and status flag with the
MPFR-based reference model and reports a mismatch as UVM_ERROR.

Every test injects a flush in 50 % of seeds, and a reset during operation in
30 % of seeds (see `Testplan/cvfpu_uvm_testplan_TESTS.csv`). The `_bp_`
tests issue requests back to back (delay 0), so the FPU deasserts
`fpu_ready_o` and stalls the input handshake.
