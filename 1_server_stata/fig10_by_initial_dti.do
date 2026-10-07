********************************************************************************
* fig10_by_initial_dti.do
*
* Figure 10: Monetary policy responses by initial debt-to-income
*   (a) debt-to-income   (b) nominal debt change   (c) Fisher dynamics
* Households are grouped by their debt-to-income quintile at the beginning of
* the year: bottom 60 percent (quintiles 1-3), 60-80 percent, top 20 percent.
*
* The same estimates, with confidence bands, are shown in Figure B4.
*
* Server output (in ${w5_tables}, .xlsx and .csv), rows stacked by group:
*   v3A_micro_DTI622groups_diff_deb_inc_r0_b1_c1_romer_iv
*   v3A_micro_DTI622groups_dti_debt_nom_r0_b1_c1_romer_iv
*   v3A_micro_DTI622groups_dti_income_total_nom_r0_b1_c1_romer_iv
* Plotted by 3_local_matlab/fig10_by_initial_dti.m and figB4_by_initial_dti_bands.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

global group_type DTI622

gen group = 1 if DTI_quintile_byyear == 1 | DTI_quintile_byyear == 2 | DTI_quintile_byyear == 3
replace group = 2 if DTI_quintile_byyear == 4
replace group = 3 if DTI_quintile_byyear == 5

foreach xx in deb_inc debt_nom income_total_nom {
	global dependent_var "`xx'"
	do programs/lp_run.do groups
}

drop group
