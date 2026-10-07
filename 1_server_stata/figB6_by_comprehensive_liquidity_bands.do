********************************************************************************
* figB6_by_comprehensive_liquidity_bands.do
*
* Figure B6 (Online Appendix): Debt-to-income responses to monetary policy by initial comprehensive liquidity measure
*
* This figure shows, with confidence bands, estimates that are also used in a
* main-text figure. The estimates are produced by fig13_by_liquidity_and_income_risk.do.
* This do-file runs that do-file unless its output already exists.
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_LIQSUBgroups_diff_deb_inc_r0_b1_c1_romer_iv
* Plotted by 3_local_matlab/figB6_by_comprehensive_liquidity_bands.m
********************************************************************************

do 00_config.do

capture confirm file "${w5_tables}/v3A_micro_LIQSUBgroups_diff_deb_inc_r0_b1_c1_romer_iv.csv"
if _rc {
	do fig13_by_liquidity_and_income_risk.do
}
else {
	di as text "Estimates for Figure B6 already exist: ${w5_tables}/v3A_micro_LIQSUBgroups_diff_deb_inc_r0_b1_c1_romer_iv.csv"
}
