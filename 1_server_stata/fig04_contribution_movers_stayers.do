********************************************************************************
* fig04_contribution_movers_stayers.do
*
* Figure 4: Movers' and stayers' contribution to nominal debt changes and Fisher dynamics
*   (a) Contribution_Deficit_StayersMovers_shares_ver1_cpi.eps
*   (b) Contribution_Fisher_StayersMovers_shares_ver1_cpi.eps
*
* The figure is drawn on the server; there is no Matlab step for this figure.
********************************************************************************

do 00_config.do

do programs/collapse_movers_stayers.do

use "${w5_temp}/new_debt_decomposition_moverstayer_ver1_cpi.dta", clear

* Figure 4(a): movers' and stayers' contributions to nominal debt changes
twoway 	///
	(bar debt_change_new_t_gmean	year if move_dum==1, lcolor(gs0) fcolor(navy) lpattern(1)) ///
	(bar debt_change_new_t_shares	year if move_dum==0, lcolor(gs0) fcolor(gs15) lpattern(1)) ///
	(line debt_change_new_t_gmean	year , lcolor(gs0) mlcolor(gs0) mfcolor(gs10) lpattern(1))  ///
	, ///
	xtitle("Year") ytitle("") ///
	legend(order(1 "Contribution of Movers' debt change" ///
			2 "Contribution of Stayers' debt change" ///
			3 "Contribution of debt change, Total"))	///
	legend(ring(0) pos(12) rows(2)) ///
	 ylabel(-5(5)25, axis(1)) ymticks(-5(2.5)27.5 , grid axis(1)) ytitle("", axis(1)) ///
	xmticks(1995(1)2015, grid) xlabel(1995(2)2015) ///
	graphregion(color(white))

	graph save "${w5_figures}/Contribution_Deficit_StayersMovers_shares_ver1_cpi.gph", replace
	graph export "${w5_figures}/Contribution_Deficit_StayersMovers_shares_ver1_cpi.eps", replace

* Figure 4(b): movers' and stayers' contributions to Fisher dynamics
twoway 	///
	(bar Fisher_effect_exact_new_t_gmean	year if move_dum==1		, lcolor(gs0) fcolor(navy) lpattern(1)) ///
	(bar Fisher_effect_exact_new_t_shares	year if move_dum==0		, lcolor(gs0) fcolor(gs15) lpattern(1)) ///
	(line Fisher_effect_exact_new_t_gmean	year 			, lcolor(gs0) mlcolor(gs0) mfcolor(gs10) lpattern(1)) ///
	, ///
	xtitle("Year") ytitle("") ///
	legend(order(1 "Contribution of Movers' Fisher dynamics" ///
			2 "Contribution of Stayers' Fisher dynamics" ///
			3 "Contribution of Fisher dynamics, Total"))	///
	legend(ring(0) pos(12) rows(2)) ///
	 ylabel(-20(5)5, axis(1)) ymticks(-20(2.5)5 , grid axis(1)) ytitle("", axis(1)) ///
	xmticks(1995(1)2015, grid) xlabel(1995(2)2015) ///
	graphregion(color(white))

	graph save "${w5_figures}/Contribution_Fisher_StayersMovers_shares_ver1_cpi.gph", replace
	graph export "${w5_figures}/Contribution_Fisher_StayersMovers_shares_ver1_cpi.eps", replace
