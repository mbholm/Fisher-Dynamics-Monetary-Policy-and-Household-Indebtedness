********************************************************************************
* fig08_market_based_shocks.do
*
* Figure 8: Decomposition of the debt-to-income response to monetary policy
* using market-based shocks
*   (a) debt-to-income change   (b) nominal debt change   (c) Fisher dynamics
*
* The market-based shocks instrument the interest rate change and the sample
* starts in 2001. The shocks are merged onto the household panel when it
* is built (variables shock_market_l0, ..., shock_market_l3).
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_all_diff_deb_inc_r0_b1_c1_market_iv
*   v3A_micro_all_dti_debt_nom_r0_b1_c1_market_iv
*   v3A_micro_all_dti_income_total_nom_r0_b1_c1_market_iv
* The log file reports the first-stage F statistic quoted in Section 4.2.
* Plotted by 3_local_matlab/fig08_market_based_shocks.m
********************************************************************************

do 00_config.do

global shock_name market
global robust 0

do programs/load_estimation_data.do

foreach xx in deb_inc debt_nom income_total_nom {
	global dependent_var "`xx'"
	do programs/lp_run.do all
}
