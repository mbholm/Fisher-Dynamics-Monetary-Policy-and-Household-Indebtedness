********************************************************************************
* fig02_decomposition_quintiles.do
*
* Figure 2: Historical decomposition of debt-to-income changes by quintiles of
* debt-to-income ratios in t-1
*   (a)-(e) Fig1_Contribution_Debt_Income_NewDecomp_Q1_ver1_cpi.eps, ..., _Q5_ver1_cpi.eps
*   (f)     Fig2_Decomp_Fisher_Q5_cpi.eps
*
* The figure is drawn on the server; there is no Matlab step for this figure.
********************************************************************************

do 00_config.do

********************************************************************************
* collapse to yearly means by debt-to-income quintile

use "${w5_data}/households_cpi_9315.dta", clear

keep 	year sample_C1 sample2 b_t delta_b_t debt_a income_total ///
	debt_change_new_t ///
	Fisher_effect_exact_new_t ///
	approx_error ///
	g_t_b_t ///
	pi_t_b_t ///
	intexp_change_t intinc_change_t income_x_nintinc_change_t ///
	income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t ///
	DTI_quintile_byyear

collapse 	delta_b_t  ///
		debt_change_new_t ///
		Fisher_effect_exact_new_t ///
		approx_error ///
		g_t_b_t ///
		pi_t_b_t ///
		intexp_change_t intinc_change_t income_x_nintinc_change_t ///
		income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t ///
		if sample2==1 & sample_C1==1 ///
		& delta_b_t!=. & debt_change_new_t!=. & Fisher_effect_exact_new_t!=. ///
		, by(year DTI_quintile_byyear)

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
foreach var of varlist g_t_b_t pi_t_b_t approx_error intinc_change_t income_x_nintinc_change_t 	income_x_nintinc_nom_g_t income_x_nintinc_nom_pi_t ///
	 {
	gen `var'NEG=-`var'
}
save "${w5_temp}/new_debt_decomposition_quintiles_ver1_cpi.dta", replace

********************************************************************************
* figures

use "${w5_temp}/new_debt_decomposition_quintiles_ver1_cpi.dta", clear

sort year

* Figure 2(a)-(d): quintiles 1 to 4
forvalues i=1/4 {

twoway 	///
	(bar debt_change_new_t	year if DTI_quintile_byyear==`i' , 	lcolor(gs1) fcolor(gs10) lpattern(1)) ///
	(bar Fisher_effect_exact_new_t	year if DTI_quintile_byyear==`i' , 	lcolor(gs1) fcolor(gs15) lpattern(1)) ///
	(line delta_b_t	year if DTI_quintile_byyear==`i', 	lcolor(gs0) lpattern(-) lwidth(medthick)) ///
	, ///
	xtitle("year")  ///
	legend(order(1 "Contribution of debt change" 2 "Contribution of Fisher dynamics" ///
		3 "Change in debt-to-income"))	///
	legend(ring(0) pos(7)) ///
	legend(rows(3)) ///
	legend(off) ///
	ylabel(-20(5)20, axis(1)) ymticks(-20(2.5)20, grid axis(1)) ytitle("Change in p.p." " " , axis(1)) ///
	xmticks(1994(1)2015, grid) xlabel(1995(2)2015) ///
	graphregion(color(white))

	graph save "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecomp_Q`i'_ver1_cpi.gph", replace
	graph export "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecomp_Q`i'_ver1_cpi.eps", replace

}

* Figure 2(e): quintile 5
gen sum_debt_income = debt_change_new_t + Fisher_effect_exact_new_t if debt_change_new_t < 0 &  Fisher_effect_exact_new_t < 0

twoway 	///
	(bar sum_debt_income	year if DTI_quintile_byyear==5  , 	lcolor(gs1) fcolor(gs10) lpattern(1)) ///
	(bar debt_change_new_t	year if DTI_quintile_byyear==5 , 	lcolor(gs1) fcolor(gs10) lpattern(1)) ///
	(bar Fisher_effect_exact_new_t	year if DTI_quintile_byyear==5 , 	lcolor(gs1) fcolor(gs15) lpattern(1)) ///
	(line delta_b_t	year if DTI_quintile_byyear==5, 	lcolor(gs0) lpattern(-) lwidth(medthick)) ///
	, ///
	xtitle("year")  ///
	legend(order(1 "Contribution of debt change" 3 "Contribution of Fisher dynamics" ///
		4 "Change in debt-to-income"))	///
	legend(ring(0) pos(7)) ///
	legend(rows(3)) ///
	ylabel(-60(10)40, axis(1)) ymticks(-60(5)40, grid axis(1)) ytitle("Change in p.p." " " , axis(1)) ///
	xmticks(1994(1)2015, grid) xlabel(1995(2)2015) ///
	graphregion(color(white))

	graph save "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecomp_Q5_ver1_cpi.gph", replace
	graph export "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecomp_Q5_ver1_cpi.eps", replace

* Figure 2(f): decomposition of Fisher dynamics in quintile 5
* (auxiliary variables that stack the bars on the correct side of zero)
* The bars are filled with shades of gray so that the figure can be read in black and white.
* Interest expenses: gs2 (dark), interest income: gs12 (light), real income growth: gs8, inflation: gs15.
cap drop total_negative
gen total_negative = income_x_nintinc_change_tNEG + intexp_change_t if intexp_change_t<0 & intinc_change_tNEG > 0
cap drop total_negative2
gen total_negative2 = income_x_nintinc_change_tNEG + intinc_change_tNEG if intexp_change_t > 0 & intinc_change_tNEG < 0
cap drop total_irate
gen total_irate = intexp_change_t + intinc_change_tNEG if intexp_change_t > 0 & intinc_change_t < 0

twoway 	///
	(bar total_negative	year if DTI_quintile_byyear==5, 	 lcolor(gs1) fcolor(gs2) lpattern(1)) 	///
	(bar total_negative2	year if DTI_quintile_byyear==5, 	lcolor(gs1) fcolor(gs12) lpattern(1)) 	///
	(bar income_x_nintinc_change_tNEG	year if DTI_quintile_byyear==5, 	lcolor(gs0) fcolor(gs15) lpattern(1)) 	///
	(bar income_x_nintinc_nom_g_tNEG  	year if DTI_quintile_byyear==5, 	lcolor(gs0) fcolor(gs8) lpattern(1)) ///
	(bar total_irate	year if intexp_change_t > 0 & intinc_change_t < 0 & DTI_quintile_byyear==5, 	lcolor(gs1) fcolor(gs12) lpattern(1)) ///
	(bar intexp_change_t	year if intexp_change_t > 0 & DTI_quintile_byyear==5, 	lcolor(gs1) fcolor(gs2) lpattern(1)) ///
	(bar intinc_change_tNEG	year if intinc_change_tNEG > 0 & total_irate==. & DTI_quintile_byyear==5, 	lcolor(gs1) fcolor(gs12) lpattern(1)) ///
	(line Fisher_effect_exact_new_t	year if DTI_quintile_byyear==5, 	lcolor(gs1) mcolor(white) msize(tiny) lpattern(1) lwidth(medthick)) ///
	, ///
	xtitle("Year")  ///
	legend(order(	1 "Change in interest expenses" ///
			2 "Change in interest income" ///
			3 "Inflation"	///
			4 "Real income growth"	///
			8 "Contribution of Fisher dynamics")) ///
	legend(ring(0) rows(2)  size(small) position(11)) ///
	ylabel(-60(10)50, axis(1)) ymticks(-60(5)60, grid axis(1)) ytitle("Change in p.p." " " , axis(1)) ///
	xmticks(1994(1)2015, grid) xlabel(1995(2)2015) ///
	graphregion(color(white))

	graph save "${w5_figures}/Fig2_Decomp_Fisher_Q5_cpi.gph", replace
	graph export "${w5_figures}/Fig2_Decomp_Fisher_Q5_cpi.eps", replace
