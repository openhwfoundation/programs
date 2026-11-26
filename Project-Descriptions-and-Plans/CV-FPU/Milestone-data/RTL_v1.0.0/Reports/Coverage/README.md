<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

# CV-FPU v1.0.0 — coverage reports

This folder holds the Questa coverage reports of the v1.0.0 regression
(`simu/fpu_reg_list`, 186 runs). There are two reports. Each folder holds the
text report and an `html/` subfolder with the HTML report:

| Folder | Content | Text report | Source UCDB |
| --- | --- | --- | --- |
| [`code_cov/`](code_cov/) | Code coverage of the DUT `/top/dut` (`fpu_wrap`, `fpnew_top` and the vendored divider): statement, branch, condition, expression and FSM, after waivers. Excluded items are shown with their `exclude.do` comment. | [`code_cov_report.txt`](code_cov/code_cov_report.txt) | `merged_excluded.ucdb` (post-waiver) |
| [`funct_cov/`](funct_cov/) | Functional coverage: covergroups and cover directives, plus assertion failure and pass counts. | [`funct_cov_report.txt`](funct_cov/funct_cov_report.txt) | `merged.ucdb` |

The code coverage report is limited to `/top/dut`. The covergroups are in the
testbench package `fpu_agent_pkg`, outside that scope, so they are in a
separate report. Waivers apply only to code coverage, so the functional report
is the same whether it is built from the UCDB before or after waivers.

## Viewing

GitHub shows the HTML files as source, not as web pages. To view an HTML
report, clone or download this repository and open `code_cov/html/index.html` or
`funct_cov/html/index.html` in a web browser. The text reports hold the same data
and can be read or searched directly.

## Results

**Code coverage**, `/top/dut`:

| Metric | Covered | Excluded | Coverage |
| --- | ---: | ---: | ---: |
| Statement | 5294 | 110 | 100.00% |
| Branch | 3170 | 201 | 100.00% |
| Condition | 160 | 7 | 100.00% |
| Expression | 2111 | 114 | 100.00% |
| FSM state | 8 | 1 | 100.00% |
| FSM transition | 13 | 3 | 100.00% |

These reports count conditions and expressions per instance and input term.
A term is listed as excluded only when every one of its FEC rows is excluded;
a term with some rows excluded and the others hit counts as covered. The
condition and expression rows of the release [`README.md`](../../README.md)
come from the recursive summary
`vcover report -code bcesf -recursive -instance=/top/dut`, and the waivers are
counted there per FEC row (41 condition rows, 487 expression rows). Both give
100% after waivers. Each waiver is justified in
[`../../Waivers/README.md`](../../Waivers/README.md).

**Functional coverage**:

| Item | Total | Hit | Coverage |
| --- | ---: | ---: | ---: |
| Covergroups (17) — bins | 8480 | 8480 | 100.00% |
| Cover directives | 66 | 66 | 100.00% |

**Assertions** are checkers, not coverage: 67, with 0 failures over the 186
runs. Questa counts an assertion as passed only if it never failed and its
condition (the left side of `|->`) was true at least once, with the check
passing. Passes with the condition never true do not count. The simulations
run without `-assertcounts`, so the Pass Count in `funct_cov_report.txt` is the
number of runs in which that happened, not the number of passes. 43 of the 67
are concurrent assertions, and all passed this way. The other 24 are parameter
checks done once at startup (`ASSERT_INIT` in `lzc` and `rr_arb_tree`), which
have no condition.

## Generating the reports

From `simu/` of cvfpu-uvm, after the regression, the merge of the per-test
coverage databases into `merged.ucdb`, and the waivers applied to give
`merged_excluded.ucdb`
([`../../Waivers/README.md`](../../Waivers/README.md)):

```
# HTML
vcover report -html -code bcefs -instance=/top/dut. -details -annotate -precision 2 -showexcluded \
    -output reports/code_cov/html regression/coverage/merged_excluded.ucdb
vcover report -html -annotate -details -precision 2 -assert -cvg -directive \
    -output reports/funct_cov/html regression/coverage/merged.ucdb

# Text
vcover report -code bcefs -instance=/top/dut. -details -precision 2 -showexcluded \
    -output reports/code_cov/code_cov_report.txt regression/coverage/merged_excluded.ucdb
vcover report -detail -option -assert -cvg -directive \
    -output reports/funct_cov/funct_cov_report.txt regression/coverage/merged.ucdb
```

The text code coverage report can also be generated with `cov_report.py` from
core-v-verif `lib/cv_dv_utils/python/sim_cmd`, which runs the same `vcover`
command and writes `report.txt`:

```
python3 ${SCRIPTS_DIR}/cov_report.py --tool questa --ucdb regression/coverage/merged_excluded.ucdb \
    --outdir reports/code_cov --instance /top/dut --details --report_type text --cover_types bcefs
```

Tool: Questa Sim-64 2025.3_2.
