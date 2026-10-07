********************************************************************************
* fig12_by_housing_tenure.do
*
* Figure 12: The debt-to-income response to monetary policy by housing tenure
*   (a) recent movers: moved within the two years before the shock (group 1)
*   (b) non-recent movers: all other households (group 2)
*
* The nominal debt change and Fisher dynamics by housing tenure, referred to in
* the text of Section 4.5, are estimated as well.
*
* Server output (in ${w5_tables}, .xlsx and .csv), rows stacked by group:
*   v3A_micro_recMovgroups_diff_deb_inc_r0_b1_c1_romer_iv
*   v3A_micro_recMovgroups_dti_debt_nom_r0_b1_c1_romer_iv
*   v3A_micro_recMovgroups_dti_income_total_nom_r0_b1_c1_romer_iv
* Plotted by 3_local_matlab/fig12_by_housing_tenure.m
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

global group_type recMov

gen group = 2
replace group = 1 if l.move_dum == 1 | l2.move_dum == 1

foreach xx in deb_inc debt_nom income_total_nom {
	global dependent_var "`xx'"
	do programs/lp_run.do groups
}

drop group
