********************************************************************************
* table01_summary_statistics.do
*
* Table 1: Summary statistics, 1994-2015
* Means across all household-year observations and within debt-to-income quintiles.
*
* Server output: ${w5_tables}/summary_stats_c1.tex
*   Columns: All, DTI1-DTI5 (debt-to-income quintiles; reported in Table 1),
*            UN0/UN1 and UN00/UN11 (below/above median predicted unemployment risk),
*            MOV0/MOV1 (stayers/movers). Only the first six columns are in the paper.
*   The last row (N) holds the number of observations.
*
* Changes relative to the code that produced the published table (the numbers in
* Table 1 are not affected):
*   - the last row is now labelled "N" (it was labelled as inflation);
*   - the share of movers is computed in a separate variable, so that the column
*     for movers (MOV1) is no longer empty.
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

cap log close
log using ${w5_log}/${version}_summary_stats_c${csample}.log, replace

********************************************************************************

tabstat deb_inc, by(year)

merge m:1 lnr using ${w5_raw}/education_nus2000.dta, nogen keep(match master) keepusing(nus yos)

* years of education, copied from Bhuller et al. (2016)
gen educ_year = .
replace educ_year = 7 if nus == 201102
replace educ_year = 7 if nus == 101101
replace educ_year = 8 if nus == 201101
replace educ_year = 9 if nus == 201103
replace educ_year = 9 if nus == 201199
replace educ_year = 9 if nus == 301110
replace educ_year = 12 if floor(nus/100000) == 3 & mod(nus,100) == 99
replace educ_year = yos - 1 if educ_year == . & yos != . & yos > 0
drop nus yos

gen GS=educ_year<=9
gen HS=educ_year>=10 & educ_year<=12
gen CO=educ_year>=13

* change in debt-to-income, nominal debt change, and Fisher dynamics (equation (1))
tsset lnr year
cap drop prim_def
cap drop Fisher_effect
gen ddeb_inc = deb_inc - l.deb_inc
gen prim_def = (debt_nom - l.debt_nom)/l.income_total_nom
gen Fisher_effect = ddeb_inc - prim_def

* units: USD 1,000 and percent
replace income_total = income_total / 1000
replace debt_a = debt_a / 1000
replace income_x_nintinc = income_x_nintinc/1000
replace income_intexp = income_intexp/1000
replace income_intinc = income_intinc/1000
replace deb_inc = deb_inc * 100
replace i_t = i_t*100
replace g_t = g_t*100
replace pi_t = pi_t*100
replace pred_unemp2 = pred_unemp2*100
replace ddeb_inc = ddeb_inc*100
replace prim_def = prim_def*100
replace Fisher_effect = Fisher_effect*100
gen move_pct = move_dum * 100

label var age "Age"
lab var GS "Less than high school education"
lab var HS "High school education"
lab var CO "College education"
label var debt_a "Debt (USD 1,000)"
label var income_total "Income (USD 1,000)"
label var income_x_nintinc "Income excl. interest"
label var income_intexp "Interest expenses"
label var income_intinc "Interest income"
label var deb_inc "Debt-to-income in %"
label var ddeb_inc "Change in debt-to-income"
label var prim_def "Nominal debt change"
label var Fisher_effect "Fisher dynamics"
label var i_t "Interest rate in %"
label var g_t "Real income growth in %"
label var pi_t "Inflation in %"
label var pred_unemp2 "Predicted job separation rate in %"
label var move_pct "Movers in %"

********************************************************************************
* means by column

local conditions `" "DTI_quintile_byyear != ." "DTI_quintile_byyear == 1" "DTI_quintile_byyear == 2" "DTI_quintile_byyear == 3" "DTI_quintile_byyear == 4" "DTI_quintile_byyear == 5" "dumUNEMP2 == 0" "dumUNEMP2 == 1" "dumUNEMP3 == 0" "dumUNEMP3 == 1" "move_dum == 0" "move_dum == 1" "'

local rowvars age GS HS CO deb_inc debt_a income_total income_x_nintinc income_intexp income_intinc ddeb_inc prim_def Fisher_effect i_t g_t pi_t pred_unemp2 move_pct

* one row per variable
local first = 1
foreach x of local rowvars {
	matrix row = J(1,12,.)
	local cc = 0
	foreach cond of local conditions {
		local cc = `cc' + 1
		qui su `x' if `cond'
		matrix row[1,`cc'] = r(mean)
	}
	if `first' == 1 matrix output = row
	else            matrix output = output\row
	local first = 0
}

* last row: number of observations
matrix row = J(1,12,.)
local cc = 0
foreach cond of local conditions {
	local cc = `cc' + 1
	qui count if age != . & `cond'
	matrix row[1,`cc'] = r(N)
}
matrix output = output\row

matrix rownames output = `rowvars' N
matrix colnames output = All DTI1 DTI2 DTI3 DTI4 DTI5 UN0 UN1 UN00 UN11 MOV0 MOV1

* outtable (option label) takes the row titles from the labels of variables with
* the names of the matrix rows, so the row of observations needs a variable too
capture drop N
gen byte N = .
label var N "Observations"

outtable using ${w5_tables}/summary_stats_c${csample}, mat(output) replace nobox center label f(%12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f)
matrix list output, format(%14.2f)

********************************************************************************
* close log file

log close
