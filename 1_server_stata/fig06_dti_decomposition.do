********************************************************************************
* fig06_dti_decomposition.do
*
* Figure 6: Decomposition of the debt-to-income response to monetary policy
*   (a) nominal debt change   (b) Fisher dynamics
*   (c) non-interest income   (d) net interest income
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_all_dti_debt_nom_r0_b1_c1_romer_iv
*   v3A_micro_all_dti_income_total_nom_r0_b1_c1_romer_iv
*   v3A_micro_all_dti_income_x_nintinc_nom_r0_b1_c1_romer_iv
*   v3A_micro_all_dti_income_nintinc_nom_r0_b1_c1_romer_iv
* Plotted by 3_local_matlab/fig06_dti_decomposition.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

foreach xx in debt_nom income_total_nom income_x_nintinc_nom income_nintinc_nom {
	global dependent_var "`xx'"
	do programs/lp_run.do all
}
