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
| [`code_cov/`](code_cov/) | Code coverage of the DUT `/top/dut` (`fpu_wrap`, `fpnew_top` and the vendored divider): statement, branch, condition and FSM, after waivers. Excluded items are shown with their `exclude.do` comment. | [`code_cov_report.txt`](code_cov/code_cov_report.txt) | `merged_excluded.ucdb` (post-waiver) |
| [`funct_cov/`](funct_cov/) | Functional coverage: covergroups, assertions (with failure and pass counts) and cover directives. | [`funct_cov_report.txt`](funct_cov/funct_cov_report.txt) | `merged.ucdb` |

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
| FSM state | 8 | 1 | 100.00% |
| FSM transition | 13 | 3 | 100.00% |

These reports count conditions per instance (160 covered, 7 excluded). The
condition row of the release [`README.md`](../../README.md) comes from the
recursive summary `vcover report -code bcsf -recursive -instance=/top/dut`,
which counts them differently (167 bins, 41 FEC rows waived). Both give 100%
after waivers. Each waiver is justified in
[`../../Waivers/README.md`](../../Waivers/README.md).

**Functional coverage**:

| Item | Total | Hit | Coverage |
| --- | ---: | ---: | ---: |
| Covergroups (17) — bins | 8480 | 8480 | 100.00% |
| Assertions | 67 | 67 | 100.00% (0 failures) |
| Cover directives | 66 | 66 | 100.00% |

## Generating the reports

From `simu/` of cvfpu-uvm, after the regression, the merge of the per-test
coverage databases into `merged.ucdb`, and the waivers applied to give
`merged_excluded.ucdb`
([`../../Waivers/README.md`](../../Waivers/README.md)):

```
# HTML
vcover report -html -code bcfs -instance=/top/dut -details -annotate -precision 2 -showexcluded \
    -output reports/code_cov/html regression/coverage/merged_excluded.ucdb
vcover report -html -annotate -details -precision 2 -assert -cvg -directive \
    -output reports/funct_cov/html regression/coverage/merged.ucdb

# Text
vcover report -code bcfs -instance=/top/dut. -details -precision 2 -showexcluded \
    -output reports/code_cov/code_cov_report.txt regression/coverage/merged_excluded.ucdb
vcover report -detail -option -assert -cvg -directive \
    -output reports/funct_cov/funct_cov_report.txt regression/coverage/merged.ucdb
```

The text code coverage report can also be generated with `cov_report.py` from
core-v-verif `lib/cv_dv_utils/python/sim_cmd`, which runs the same `vcover`
command and writes `report.txt`:

```
python3 ${SCRIPTS_DIR}/cov_report.py --tool questa --ucdb regression/coverage/merged_excluded.ucdb \
    --outdir reports/code_cov --instance /top/dut --details --report_type text --cover_types bcfs
```

Tool: Questa Sim-64 2025.3_2.
