********************************************************************************
* lp_groups_diff.do
* Local projection (IV), separately by household group: change in a ratio (debt-to-income).
*
* Called by the figure do-files through programs/lp_run.do. Requires the data loaded by
* programs/load_estimation_data.do and the globals set in 00_config.do, plus
*   $dependent_var  outcome variable
*   $shock_name     romer (narrative shocks) or market (market-based shocks)
*   group           variable in memory holding the household group (1,2,...); $group_type its name
* Output: one row per horizon h = 0,...,$NN (stacked by group): estimate, standard error, observations.
********************************************************************************
********************************************************************************
* open log-file

cap log close
log using ${w5_log}/${version}_micro_${group_type}groups_diff_${dependent_var}${sample}_r${robust}_b${balance}_c${csample}_${shock_name}_iv.log, replace


********************************************************************************
* calculate log differences of dependent variable for each HH at horizons h=0,1,...,NN


* generate average
tsset lnr year

forval j = 0/$NN  {
	qui gen ${dependent_var}_d`j' = (f`j'.${dependent_var} - l1.${dependent_var})
	}


* generate control vars
g control_1 = (l1.${dependent_var}- l2.${dependent_var}) 
g control_2 = (l2.${dependent_var} - l3.${dependent_var})

cap drop balance
gen balance = 1

if ${balance}==1 {
	cap drop balance
	gen balance = ${dependent_var}_d0 != . & ${dependent_var}_d1 != . & ${dependent_var}_d2 != . & ${dependent_var}_d3 != . & ${dependent_var}_d4 != . & ${dependent_var}_d5 != .
}
	
********************************************************************************
* Local Projections

* calculate number of groups used
qui su group, meanonly 
local group_nb = r(max)		
		
* make matrices ready
matrix res = J(($NN+1)*`group_nb',1,0)
matrix seRes = J(($NN+1)*`group_nb',1,0)
matrix NObs = J(($NN+1)*`group_nb',1,0)		
*gen sample = ${dependent_var}_d0 != . & ${dependent_var}_d1 != . & ${dependent_var}_d2 != . & ${dependent_var}_d3 != . & ${dependent_var}_d4 != . & ${dependent_var}_d5 != .
				
forval kk=1/`group_nb' {
preserve
keep if group == `kk'

forval j=0/$NN {



	
	if "${shock_name}"=="market" {
		eststo: qui xtivreg2 ${dependent_var}_d`j' (d_ir_eoy = shock_l0) shock_l1 shock_l2 shock_l3 control_* $demogr_controls if group == `kk' & DTI_jan_1st != . & balance == 1 & year >= 2001, fe dkraay($DK_lag)
	}
	else {
		eststo: qui xtivreg2 ${dependent_var}_d`j' (d_ir_eoy = shock_l0) shock_l1 shock_l2 shock_l3 control_* $demogr_controls if group == `kk' & DTI_jan_1st != . & balance == 1, fe dkraay($DK_lag)
	}
	
	
	
	di as text "horizon `j': first-stage F (Kleibergen-Paap rk Wald) = " %9.2f e(widstat) "   N = " e(N)

	*store results
	local jnum = `j'+1
	matrix beta = e(b)
	matrix res[(`kk'-1)*($NN+1)+`jnum',1] = beta[1,1]
	mat VV = e(V)
	matrix seRes[(`kk'-1)*($NN+1)+`jnum',1] = sqrt(VV[1,1])
	matrix NObs[(`kk'-1)*($NN+1)+`jnum',1] = e(N)
	
	}
	
	* show estimates
	if $show_output==1 {
	esttab, se compress replace
	}
	eststo clear
	
restore
}

* delete log-differences
drop ${dependent_var}_d* control_*
drop balance
	
********************************************************************************
* output estimates into excel file	

putexcel set ${w5_tables}/${version}_micro_${group_type}groups_diff_${dependent_var}${sample}_r${robust}_b${balance}_c${csample}_${shock_name}_iv.xlsx, replace
* first column contains point estimates (for h=0,1,...,NN)
putexcel A1 = matrix(res)
* second column contains standard errors	
putexcel B1 = matrix(seRes)
* third column contains sample size
putexcel C1 = matrix(NObs)

* same estimates as comma-separated text (columns: estimate, standard error, observations)
write_lp_csv "${w5_tables}/${version}_micro_${group_type}groups_diff_${dependent_var}${sample}_r${robust}_b${balance}_c${csample}_${shock_name}_iv.csv"


********************************************************************************
* close log file

log close
