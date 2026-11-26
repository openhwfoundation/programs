<!--
Copyright 2026, Eclipse Foundation
SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
-->

### TRL-5 Reports and Checklist for the CV-FPU

The OpenHW Foundation asserts that the documentation, implementation and
verification of the CV-FPU v1.0.0 meet the criteria for Technology Readiness
Level 5. The directories and files below this point hold the completed
checklists, reports and waivers in support of this claim.

**RTL_v1.0.0**:
- README.md: scope of verification, verified configuration, frozen RTL, and summary tables of the results.
- OpenHWFdn_TRL5_CVFPU_Checklist.xlsx: checklists for the v1.0.0 tag of CV-FPU (one tab per checklist; the same tables are in OpenHWFdn_TRL5_CVFPU_Checklist/*.csv).
- CVFPU_waiver_list.xlsx: every waived code coverage item, with its `exclude.do` command and proof.
- CVFPU_Design_Issue_Summary.xlsx: GitHub issues of openhwgroup/cvfpu at release time, and their waiver status.
- Testplan: verification plan of the cvfpu-uvm environment.
- Waivers: `exclude.do`, the explanation of how it is organised and applied, and one proof file per waiver category.
- Reports: coverage (HTML), simulation regression and RTL lint reports.
