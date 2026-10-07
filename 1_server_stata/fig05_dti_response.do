********************************************************************************
* fig05_dti_response.do
*
* Figure 5: The debt-to-income response to monetary policy
*
* Server output (in ${w5_tables}, .xlsx and .csv):
*   v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv
* The log file reports the first-stage F statistic quoted in Section 4.1.
* Plotted by 3_local_matlab/fig05_dti_response.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

global dependent_var deb_inc
do programs/lp_run.do all
