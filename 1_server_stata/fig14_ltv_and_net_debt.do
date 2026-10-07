********************************************************************************
* fig14_ltv_and_net_debt.do
*
* Figure 14: Loan-to-value and net debt responses to monetary policy
*   (a) loan-to-value: debt relative to housing wealth
*   (b) net debt-to-income: debt minus deposits, relative to disposable income
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_all_diff_ltv_hou_r0_b1_c1_romer_iv
*   v3A_micro_all_diff_ndeb_inc_r0_b1_c1_romer_iv
* Plotted by 3_local_matlab/fig14_ltv_and_net_debt.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

foreach xx in ltv_hou ndeb_inc {
	global dependent_var "`xx'"
	do programs/lp_run.do all
}
