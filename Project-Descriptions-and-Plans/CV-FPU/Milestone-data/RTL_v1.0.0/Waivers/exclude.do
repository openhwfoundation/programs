#  Copyright (c) 2026 Eclipse Foundation
#
#  SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

# 1: Undriven rounding modes: RMM/ROD
# 1.1 RMM not stimulated
coverage exclude -du ct_vfdsu_prepare -code s -linerange 590 -comment {RMM is omitted because the current reference model cannot check it.}
coverage exclude -du ct_vfdsu_prepare -code b -linerange 590 -comment {RMM is omitted because the current reference model cannot check it.}
coverage exclude -du ct_vfdsu_round -code b -linerange 905 -comment {RMM is omitted because the current reference model cannot check it.}
coverage exclude -du ct_vfdsu_round -code s -linerange 907-910 -comment {RMM is omitted because the current reference model cannot check it.}
coverage exclude -du ct_vfdsu_round -code b -linerange 907-910 -comment {RMM is omitted because the current reference model cannot check it.}
coverage exclude -du fpnew_rounding -code s -linerange 58-59 -comment {RMM lacks reference-model checking; ROD has no scalar RISC-V encoding.}
coverage exclude -du fpnew_rounding -code b -linerange 58-59 -comment {RMM lacks reference-model checking; ROD has no scalar RISC-V encoding.}
# 1.3 Reserved encodings in the C910 divider
coverage exclude -du ct_vfdsu_prepare -code b -linerange 591 -comment {Reserved rounding encodings cannot reach this scalar arithmetic path.}
coverage exclude -du ct_vfdsu_prepare -code s -linerange 591 -comment {Reserved rounding encodings cannot reach this scalar arithmetic path.}
coverage exclude -du ct_vfdsu_round -code b -linerange 912 -comment {Reserved rounding encodings cannot reach this scalar arithmetic path.}
coverage exclude -du ct_vfdsu_round -code s -linerange 914-917 -comment {Reserved rounding encodings cannot reach this scalar arithmetic path.}

# 2: FPU config: vector operations are disabled
# 2.1 Vector decode, operand replication and vector-only branches
coverage exclude -du fpu_wrap -code b -linerange 163 -item b 1 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 163 -item b 1 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -du fpu_wrap -code b -linerange 170 -item b 2 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 320 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 325 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 330 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 335 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 340 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 345 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 350 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 356 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 361 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 367 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 372 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 378 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 385 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 392 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 399 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 163 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 321-322 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 326-327 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 331-332 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 336-337 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 341-342 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 346-347 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 351-353 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 357-358 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 362-364 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 368-369 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 373-375 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 379-382 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 386-389 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 393-396 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 400-403 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 413 -item b 1 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 413 -item b 1 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -du fpu_wrap -code b -linerange 414 426 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code c -item c 1 -feccondrow 413 2 3 4 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 415-425 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 417 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 419 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 422 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code b -linerange 427-437 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 429 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 431 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpu_wrap -code s -linerange 434 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 245 -item b 1 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -du fpnew_opgroup_fmt_slice -code b -linerange 284 -item b 1 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/conv_target} -code b -linerange 149 -item b 1 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code b -linerange 218 -item b 1 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code b -linerange 218 -item b 1 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code b -linerange 223 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code c -item c 1 -feccondrow 218 2 3 4 5 6 -comment {XFVec=0 prevents vector execution and replication.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code s -linerange 219 -comment {XFVec=0 prevents vector execution and replication.}
# 2.2 `fpu_vec_op_d` in the AH check
coverage exclude -du fpu_wrap -feccondrow 410 2 -comment {XFVec=0 fixes fpu_vec_op_d to zero; only its true FEC row is unreachable.}
# 2.3 Vector bypass pipeline of the CONV slice
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[1]} -code b -linerange 489 -item b 3 -comment {Vector bypass valid and external register enable are both tied low.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[1]} -code b -linerange 489 -item b 3 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[1]} -code b -linerange 490 -item b 3 -comment {Vector bypass valid and external register enable are both tied low.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[1]} -code b -linerange 490 -item b 3 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[1]} -code s -linerange 489 -item s 3 -comment {Vector bypass valid and external register enable are both tied low.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/target_regs/gen_bypass_pipeline[1]} -code s -linerange 490 -item s 3 -comment {Vector bypass valid and external register enable are both tied low.}
# 2.4 NaN-box check bypass
coverage exclude -du fpnew_top -code b -linerange 92 -comment {Scalar mode always checks NaN boxing; the vector bypass is unreachable.}
# 2.5 SIMD lane synchronisation in the divider
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 393 394 -item b 1 -comment {XFVec=0 keeps result_vec_op_q low, so the per-lane NaN-boxed operand is never selected.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 236 -item b 4 -comment {Scalar mode forces unit_done_clear high, preventing unit_done_q from loading.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 236 -item s 4 -comment {Scalar mode forces unit_done_clear high, preventing unit_done_q from loading.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code c -item c 1 -feccondrow 267 2 4 -comment {Scalar mode fixes result_vec_op_q and SIMD completion feedback to zero.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 431 -item b 1 -comment {Scalar mode keeps unit_done_q zero, bypassing held results.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 432 -item b 1 -comment {Scalar mode keeps unit_done_q zero, bypassing held results.}

# 3: FPU config: FP8 and FP16ALT formats are disabled
# 3.1 Format decode in `fpu_wrap`
coverage exclude -du fpu_wrap -code b -linerange 410 -item b 2 -comment {Supported scalar encodings keep the AH format-select bit low.}
coverage exclude -du fpu_wrap -code b -linerange 410 -item b 2 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -du fpu_wrap -code s -linerange 410 -item s 1 -comment {Supported scalar encodings keep the AH format-select bit low.}
coverage exclude -du fpu_wrap -code b -linerange 278-280 -comment {XF8=XF16ALT=0 disables these format selections.}
# 3.2 FP16ALT in the divider format translation
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 171 -comment {XF16ALT=0 disables alternate-half divsqrt.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 171 -comment {XF16ALT=0 disables alternate-half divsqrt.}
# 3.3 Round-robin state of the format arbiters
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} -code b -linerange 198 -item b 2 -comment {Disabled FP8 and FP16ALT requests keep rr_q below their indices.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} -code b -linerange 199 -item b 1 -comment {Disabled FP8 and FP16ALT requests keep rr_q below their indices.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} -code b -linerange 289 -item b 1 -comment {Both child requests are zero, fixing this tree selector high.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[1]/gen_level[1]/gen_other_levels} -code b -linerange 291 -item b 2 -comment {Both child requests are zero, fixing this tree selector high.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_lower/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_lower/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_lower/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_lower/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_not_last_level/g_level[1]} -code b -linerange 96 -item b 1 -comment {This subtree contains only the disabled FP16ALT request and padding.}

# 4: FPU config: DIVSQRT and CONV use MERGED units
# 4.1 Format-arbiter masks and next index (DIVSQRT, CONV)
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb} -code b -linerange 220 -item b 2 -comment {MERGED slices expose only FP32-index valid; other format requests are tied low.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb} -code b -linerange 220 -item b 2 -comment {MERGED slices expose only FP32-index valid; other format requests are tied low.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[2]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[2]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} -code b -linerange 198 -item b 2 -comment {MERGED slices expose only FP32-index valid; other format requests are tied low.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[2]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[1]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[2]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[3]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[4]} -code b -linerange 199 -item b 1 -comment {MERGED slices expose only FP32-index valid; other format requests are tied low.}
# 4.2 Leaf select for indices 2/3 (DIVSQRT, CONV)
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[2]/gen_level[1]/gen_first_level/gen_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_levels[2]/gen_level[1]/gen_first_level/gen_reduce} -code b -linerange 262 -item b 2 -comment {MERGED slices tie the FP16 and FP8 requests low, fixing this leaf selector high.}
# 4.3 FP16 leaf of the LZCs (DIVSQRT, CONV)
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_lower/gen_lzc/g_levels[2]/g_last_level/g_level[1]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[2]/g_last_level/g_level[1]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_lower/gen_lzc/g_levels[2]/g_last_level/g_level[1]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[2]/g_last_level/g_level[1]/g_reduce} -code b -linerange 77 -item b 1 -comment {MERGED slices tie the FP16 request low.}
# 4.4 Upper-LZC internal node over bits 0–1 (DIVSQRT, CONV)
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_not_last_level/g_level[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_not_last_level/g_level[0]} -code b -linerange 96 -item b 1 -comment {Upper-mask bit zero and the MERGED FP64 request are both tied low.}
# 4.5 Upper-LZC root (DIVSQRT, CONV)
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[0]/g_not_last_level/g_level[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[0]/g_not_last_level/g_level[0]} -code b -linerange 96 -item b 1 -comment {Upper-mask tie-offs and MERGED requests make this child subtree zero.}

# 5: fpu_wrap ties fpu_out_ready to 1
# 5.1 Top-level arbiter grant
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb} -code c -item c 1 -feccondrow 221 1 -comment {The dedicated FPU write port ties this arbiter grant input high.}
# 5.2 Divider HOLD state
coverage exclude -du fpnew_divsqrt_th_64_multi -fstate state_q {HOLD} -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 277 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 278 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 283 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 287 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 284-285 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 288 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 289 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code c -linerange 289 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 290-291 -comment {The always-ready fair arbiter drains the buffer before the next completion.}
# 5.3 Hold-register enable
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 422 -item b 1 -comment {Scalar hold_en reduces to the unreachable output-stall completion condition.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 422 -item b 1 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 423 -item b 1 -comment {Scalar hold_en reduces to the unreachable output-stall completion condition.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code b -linerange 423 -item b 1 -allfalse -clear -comment {The false outcome is exercised; only the enabled arm is unreachable.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 422 -item s 2 -comment {Scalar hold_en reduces to the unreachable output-stall completion condition.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code s -linerange 423 -item s 2 -comment {Scalar hold_en reduces to the unreachable output-stall completion condition.}

# 6: Structurally unreachable
# 6.1 Static rounding mode tied to 111 (C910 prepare)
coverage exclude -du ct_vfdsu_prepare -code b -linerange 575 -comment {Static RM is tied to 111, so only the external RM input is selected.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 573 1 3 4 -comment {Static RM is tied to 111, so only the external RM input is selected.}
# 6.2 Double and single format flags never both set (C910 round)
coverage exclude -du ct_vfdsu_round -code b -linerange 971 -comment {Single and double format flags are mutually exclusive.}
coverage exclude -du ct_vfdsu_round -code s -linerange 973-974 -comment {Single and double format flags are mutually exclusive.}
# 6.3 ADDS is never issued
coverage exclude -du fpnew_fma -code b -linerange 202 -comment {Wrapper decode emits ADD and never ADDS.}
coverage exclude -du fpnew_opgroup_multifmt_slice -code b -linerange 205 -item b 1 -comment {ADDS is never issued; DIVSQRT also has no third operand.}
coverage exclude -du fpnew_opgroup_multifmt_slice -code c -item c 1 -feccondrow 205 2 -comment {ADDS is never issued; DIVSQRT also has no third operand.}
# 6.4 DIVSQRT has no third operand
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code b -linerange 204 -item b 1 -comment {DIVSQRT has two operands, so its third-operand path is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code b -linerange 205 -item b 2 -comment {DIVSQRT has two operands, so its third-operand path is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code c -item c 1 -feccondrow 204 2 -comment {DIVSQRT has two operands, so its third-operand path is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code c -item c 1 -feccondrow 205 1 -comment {DIVSQRT has two operands, so its third-operand path is unreachable.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane} -code s -linerange 205 -item s 1 -comment {DIVSQRT has two operands, so its third-operand path is unreachable.}
# 6.5 Default arms of complete case statements (C910)
coverage exclude -du ct_vfdsu_ctrl -code b -linerange 220 -comment {Both values of the one-bit SRT state are handled.}
coverage exclude -du ct_vfdsu_ctrl -code s -linerange 220 -comment {Both values of the one-bit SRT state are handled.}
coverage exclude -du ct_vfdsu_ff1 -code b -linerange 91 -comment {Priority casez patterns plus the zero arm cover every known input.}
coverage exclude -du ct_vfdsu_ff1 -code s -linerange 91 -comment {Priority casez patterns plus the zero arm cover every known input.}
coverage exclude -du ct_vfdsu_pack -code b -linerange 162 -comment {The 00, 01 and 1? arms cover every known selector value.}
coverage exclude -du ct_vfdsu_pack -code s -linerange 162 -comment {The 00, 01 and 1? arms cover every known selector value.}
coverage exclude -du ct_vfdsu_pack -code b -linerange 377 -comment {The 00, 01 and 1? arms cover every known selector value.}
coverage exclude -du ct_vfdsu_pack -code s -linerange 377 -comment {The 00, 01 and 1? arms cover every known selector value.}
# 6.6 SRT bound-table default
coverage exclude -du ct_vfdsu_srt_radix16_bound_table -code b -linerange 950 -comment {Partial roots stay in [1/4, 1/2] and divisors are normalized, so bound_sel is always 0 or 40-7f.}
coverage exclude -du ct_vfdsu_srt_radix16_bound_table -code s -linerange 952-960 -comment {Partial roots stay in [1/4, 1/2] and divisors are normalized, so bound_sel is always 0 or 40-7f.}
# 6.7 Effective subtraction in conversions
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/gen_merged_slice/i_multifmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fpnew_cast_multi/i_fpnew_rounding} -code b -linerange 73 -comment {Conversion ties effective_subtraction_i low.}
# 6.8 `unit_ready` at the divider issue decisions
coverage exclude -du fpnew_divsqrt_th_64_multi -code c -item c 1 -feccondrow 259 3 -comment {The issue/completion protocol makes unit_ready high at this decision.}
coverage exclude -du fpnew_divsqrt_th_64_multi -code c -item c 1 -feccondrow 273 3 -comment {The issue/completion protocol makes unit_ready high at this decision.}
# 6.9 C910 NaN-propagation mode tied off
coverage exclude -du ct_vfdsu_prepare -code b -linerange 650-657 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code s -linerange 650-657 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 650 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 652 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 654 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 656 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code b -linerange 677-684 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code s -linerange 677-684 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 677 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 679 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 681 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
coverage exclude -du ct_vfdsu_prepare -code c -item c 1 -feccondrow 683 2 4 -comment {The wrapper ties vfpu_yy_xx_dqnan low.}
# 6.10 Integer destination in the DIVSQRT group
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice} -code b -linerange 141 -item b 1 -comment {DIVSQRT results cannot have an integer destination format.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/gen_merged_slice/i_multifmt_slice} -code b -linerange 520 -item b 1 -comment {DIVSQRT results cannot have an integer destination format.}
# 6.11 Classify result in the ADDMUL group
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[0]/active_format/i_fmt_slice} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[2]/active_format/i_fmt_slice} -code b -linerange 287 -item b 1 -comment {ADDMUL ties lane_is_class low because FMA cannot classify.}
# 6.12 EX1 always sees `op_sel = 1` (C910 control)
coverage exclude -du ct_vfdsu_ctrl -code b -linerange 433 -comment {op_sel tracks EX1; a flush resets both before they can diverge.}
coverage exclude -du ct_vfdsu_ctrl -code s -linerange 434 -comment {op_sel tracks EX1; a flush resets both before they can diverge.}
# 6.13 Round-robin mask index 0
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} -code b -linerange 198 -item b 1 -comment {Input zero compares 0 against the unsigned rr_q, so 0 > rr_q is never true.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} {/top/dut/fpu_gen/i_fpnew_bulk/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/gen_mask[0]} -code b -linerange 199 -item b 2 -comment {Input zero compares 0 against the unsigned rr_q, so 0 <= rr_q is always true.}
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[2]/g_last_level/g_level[0]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[1]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[2]/g_last_level/g_level[0]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[2]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[2]/g_last_level/g_level[0]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[3]/i_opgroup_block/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[2]/g_last_level/g_level[0]/g_reduce} {/top/dut/fpu_gen/i_fpnew_bulk/i_arbiter/gen_arbiter/gen_int_rr/gen_fair_arb/i_lzc_upper/gen_lzc/g_levels[1]/g_last_level/g_level[0]/g_reduce} -code b -linerange 77 -item b 1 -comment {The upper arbitration mask ties bit zero low.}
# 6.14 FMA leading-zero-counter padding
coverage exclude -scope {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[0]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[3]/g_not_last_level/g_level[7]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[0]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[4]/g_not_last_level/g_level[13]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[0]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[4]/g_not_last_level/g_level[14]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[0]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[4]/g_not_last_level/g_level[15]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[3]/g_not_last_level/g_level[7]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[4]/g_not_last_level/g_level[14]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[4]/g_not_last_level/g_level[15]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[5]/g_not_last_level/g_level[28]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[5]/g_not_last_level/g_level[29]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[5]/g_not_last_level/g_level[30]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[1]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[5]/g_not_last_level/g_level[31]} {/top/dut/fpu_gen/i_fpnew_bulk/gen_operation_groups[0]/i_opgroup_block/gen_parallel_slices[2]/active_format/i_fmt_slice/gen_num_lanes[0]/active_lane/lane_instance/i_fma/i_lzc/gen_lzc/g_levels[3]/g_not_last_level/g_level[7]} -code b -linerange 96 -item b 1 -comment {The selected child subtree contains only constant-zero tree padding.}
