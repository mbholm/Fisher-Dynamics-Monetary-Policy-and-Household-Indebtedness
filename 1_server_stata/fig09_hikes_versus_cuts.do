********************************************************************************
* fig09_hikes_versus_cuts.do
*
* Figure 9: The debt-to-income response to interest rate hikes and cuts
*   (a) only positive monetary policy shocks instrument the interest rate change
*   (b) only negative monetary policy shocks instrument the interest rate change
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv_pos
*   v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv_neg
* Plotted by 3_local_matlab/fig09_hikes_versus_cuts.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

global dependent_var deb_inc
do programs/lp_run.do all pos
do programs/lp_run.do all neg
