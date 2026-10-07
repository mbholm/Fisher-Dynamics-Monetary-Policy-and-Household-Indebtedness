********************************************************************************
* figB4_by_initial_dti_bands.do
*
* Figure B4 (Online Appendix): Debt-to-income responses to monetary policy by initial debt-to-income
*
* This figure shows, with confidence bands, estimates that are also used in a
* main-text figure. The estimates are produced by fig10_by_initial_dti.do.
* This do-file runs that do-file unless its output already exists.
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_DTI622groups_diff_deb_inc_r0_b1_c1_romer_iv
* Plotted by 3_local_matlab/figB4_by_initial_dti_bands.m
********************************************************************************

do 00_config.do

capture confirm file "${w5_tables}/v3A_micro_DTI622groups_diff_deb_inc_r0_b1_c1_romer_iv.csv"
if _rc {
	do fig10_by_initial_dti.do
}
else {
	di as text "Estimates for Figure B4 already exist: ${w5_tables}/v3A_micro_DTI622groups_diff_deb_inc_r0_b1_c1_romer_iv.csv"
}
