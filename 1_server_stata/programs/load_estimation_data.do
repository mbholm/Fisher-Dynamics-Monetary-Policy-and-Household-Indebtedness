********************************************************************************
* load_estimation_data.do
*
* Loads the household panel and prepares the variables used in all local
* projections. Called at the top of every impulse-response do-file.
*
* Requires the globals from 00_config.do and, set by the calling do-file,
*   $shock_name   romer  = narrative shocks from Holm, Paul, and Tischbirek (2021)
*                 market = market-based shocks from Brubakk et al. (2022)
*   $robust       0 = all shocks; 1 = shocks from 2008 onward set to zero
********************************************************************************

* dependent variables that are stored in the data set (the remaining ones are generated below)
local dependent_vars_AlreadyGenerated debt_nom income_total_nom income_x_nintinc_nom income_nintinc_nom

* load the data
clear
u `dependent_vars_AlreadyGenerated' d_ir* ndebt2_nom income_x_nintinc income_intexp income_intinc sifo_hh_expenses_a housing_wealth_a sector ndebt_nom housing_wealth_nom LTVHOU income_total_nom debt_nom dumUNEMP* pred_unemp* income_total age_group Fisher* income_growth_* d_t* DTI* move_dum sample* saving_housing_a lottery_a inheritance_a *shock* debt_a wealth_a cap_inc_gross_a cap_exp_gross_a cap_inc_dividends_a cap_inc_interest_a cons_incl_housing_a cons_excl_housing_a noise uncapgains_a uncapgains_housing_a uncapgains_stocks_a uncapgains_mfund_a net_inc_a cap_inc_a transfers_a taxes_a earned_income_a taxes_a transfers_a cap_inc_a lnr year age cpi stocks_a bonds_a grunnbelop mfund_a deposits_a bus_inc_a hhid i_t g_t pi_t age using ${w5_data}/households_cpi_9315${sample}

keep if sample2 == 1

if $csample==1 {
	keep if sample_C1 == 1
}
if $csample==2 {
	keep if sample_C2 == 1
}

********************************************************************************
* generate variables, declare panel format
tsset lnr year

qui g income_ndti = income_total_nom
qui g ndebt_ndti = ndebt_nom
qui g ndeb_inc = ndebt_nom / income_total_nom
qui g ndebt2_ndti = ndebt2_nom
qui g ndeb2_inc = ndebt2_nom / income_total_nom

qui g housing_ltv = housing_wealth_nom
qui g debt_ltv = debt_nom
qui g ltv_hou = debt_nom / housing_wealth_nom

* winsorize ltv_hou
replace ltv_hou = 0 if housing_wealth_nom == 0
replace ltv_hou = 1 if ltv_hou > 1

qui g deb_inc = debt_nom / income_total_nom

cap drop shock*l4

replace d_ir = d_ir/100
replace d_ir_eoy = d_ir_eoy/100

* choice of monetary policy shock series
if "${shock_name}"=="romer" {
	drop shock_market*
}

if "${shock_name}"=="market" {
	replace shock_l0 = shock_market_l0
	replace shock_l1 = shock_market_l1
	replace shock_l2 = shock_market_l2
	replace shock_l3 = shock_market_l3

	drop shock_market*
}

* robustness: exclude monetary policy shocks from 2008 onward
if ${robust}==1 {
	replace shock_l0 = 0 if year >= 2008
	replace shock_l1 = 0 if year >= 2009
	replace shock_l2 = 0 if year >= 2010
	replace shock_l3 = 0 if year >= 2011
}

* interest rate hikes and cuts separately
gen shock_l0_pos = shock_l0*(shock_l0 >= 0)
gen shock_l0_neg = shock_l0*(shock_l0 <= 0)

* declare data to be in panel format
tsset lnr year
