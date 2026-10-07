********************************************************************************
* figB3_excluding_shocks_after_2008.do
*
* Figure B3 (Online Appendix): Decomposition of the debt-to-income response to
* monetary policy. Robustness to excluding monetary policy shocks after 2008.
*   (a) debt-to-income change   (b) nominal debt change   (c) Fisher dynamics
*
* With $robust = 1 the monetary policy shocks from 2008 onward are set to zero
* (see programs/load_estimation_data.do).
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_all_diff_deb_inc_r1_b1_c1_romer_iv
*   v3A_micro_all_dti_debt_nom_r1_b1_c1_romer_iv
*   v3A_micro_all_dti_income_total_nom_r1_b1_c1_romer_iv
* Plotted by 3_local_matlab/figB3_excluding_shocks_after_2008.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 1

do programs/load_estimation_data.do

foreach xx in deb_inc debt_nom income_total_nom {
	global dependent_var "`xx'"
	do programs/lp_run.do all
}
