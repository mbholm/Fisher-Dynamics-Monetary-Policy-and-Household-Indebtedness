********************************************************************************
* collapse_movers_stayers.do
*
* Yearly means of the debt-to-income decomposition for movers and stayers, and
* each group's contribution to the population average. Used by
* fig03_decomposition_movers_stayers.do and fig04_contribution_movers_stayers.do.
*
* Output: ${w5_temp}/new_debt_decomposition_moverstayer_ver1_cpi.dta
********************************************************************************

use "${w5_data}/households_cpi_9315.dta", clear

keep 	year sample_C1 sample2 b_t delta_b_t debt_a income_total ///
	debt_change_new_t ///
	Fisher_effect_exact_new_t ///
	approx_error ///
	g_t_b_t ///
	pi_t_b_t ///
	intexp_change_t intinc_change_t income_x_nintinc_change_t ///
	income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t ///
	DTI_quintile_byyear ///
	move_dum mover_share stayer_share

collapse 	delta_b_t  ///
		debt_change_new_t ///
		Fisher_effect_exact_new_t ///
		approx_error ///
		g_t_b_t ///
		pi_t_b_t ///
	intexp_change_t intinc_change_t income_x_nintinc_change_t ///
	income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t ///
		 mover_share stayer_share ///
		if sample2==1 & sample_C1==1 ///
		& delta_b_t!=. & debt_change_new_t!=. & Fisher_effect_exact_new_t!=. ///
		, by(year move_dum)

* in percentage points
foreach var of varlist delta_b_t  ///
		debt_change_new_t ///
		Fisher_effect_exact_new_t ///
		approx_error ///
		g_t_b_t ///
		pi_t_b_t ///
	intexp_change_t intinc_change_t income_x_nintinc_change_t ///
	income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t ///
		{
	replace `var'=`var'*100
}

* income contributions enter with a negative sign in the figures
foreach var of varlist 	 	g_t_b_t pi_t_b_t approx_error ///
	 	intexp_change_t intinc_change_t income_x_nintinc_change_t ///
	income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t {
	gen `var'NEG=-`var'
}

* population mean as the share-weighted mean of movers and stayers
foreach var of varlist debt_change_new_t delta_b_t Fisher_effect_exact_new_t   {
gen	`var'_shares=	`var'*mover_share if move_dum==1
replace `var'_shares=	`var'*stayer_share if move_dum==0
bysort year:egen `var'_gmean=	total(`var'_shares)
}

save "${w5_temp}/new_debt_decomposition_moverstayer_ver1_cpi.dta", replace
