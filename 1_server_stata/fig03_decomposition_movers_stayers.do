********************************************************************************
* fig03_decomposition_movers_stayers.do
*
* Figure 3: Historical decomposition of debt-to-income changes for movers and stayers
*   (a) stayers: Fig1_Contribution_Debt_Income_NewDecompMean_Move0_ver1_cpi.eps (with legend)
*   (b) movers:  Fig1_Contribution_Debt_Income_NewDecompMean_Move1_ver2_cpi.eps (without legend)
*
* The figure is drawn on the server; there is no Matlab step for this figure.
********************************************************************************

do 00_config.do

do programs/collapse_movers_stayers.do

use "${w5_temp}/new_debt_decomposition_moverstayer_ver1_cpi.dta", clear

forvalues i=0/1 {

* version 1: with legend (used for stayers, panel a)
twoway 	///
	(bar debt_change_new_t	year if move_dum==`i' , 	lcolor(gs1) fcolor(gs10) lpattern(1)) ///
	(bar Fisher_effect_exact_new_t	year if move_dum==`i' , 	lcolor(gs1) fcolor(gs15) lpattern(1)) ///
	(line delta_b_t	year if move_dum==`i', 	lcolor(gs0) lpattern(-) lwidth(medthick)) ///
	, ///
	xtitle("year")  ///
	legend(order(1 "Contribution of debt change" 2 "Contribution of Fisher dynamics" ///
		3 "Change in debt-to-income"))	///
	legend(ring(0) pos(13) rows(3)) ///
	ylabel(-20(20)120, axis(1)) ymticks(-20(20)120, grid axis(1)) ytitle("Change in p.p." " " , axis(1)) ///
	xmticks(1994(1)2014, grid) xlabel(1995(2)2014) ///
	graphregion(color(white))

	graph save "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecompMean_Move`i'_ver1_cpi.gph", replace
	graph export "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecompMean_Move`i'_ver1_cpi.eps", replace

* version 2: without legend (used for movers, panel b)
twoway 	///
	(bar debt_change_new_t	year if move_dum==`i' , 	lcolor(gs1) fcolor(gs10) lpattern(1)) ///
	(bar Fisher_effect_exact_new_t	year if move_dum==`i' , 	lcolor(gs1) fcolor(gs15) lpattern(1)) ///
	(line delta_b_t	year if move_dum==`i', 	lcolor(gs0) lpattern(-) lwidth(medthick)) ///
	, ///
	xtitle("year")  ///
	legend(order(1 "Contribution of debt change" 2 "Contribution of Fisher dynamics" ///
		3 "Change in debt-to-income"))	///
	legend(rows(3)) ///
	legend(off) ///
	ylabel(-20(20)120, axis(1)) ymticks(-20(20)120, grid axis(1)) ytitle("Change in p.p." " " , axis(1)) ///
	xmticks(1994(1)2014, grid) xlabel(1995(2)2014) ///
	graphregion(color(white))

	graph save "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecompMean_Move`i'_ver2_cpi.gph", replace
	graph export "${w5_figures}/Fig1_Contribution_Debt_Income_NewDecompMean_Move`i'_ver2_cpi.eps", replace
}
