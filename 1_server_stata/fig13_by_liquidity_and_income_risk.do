********************************************************************************
* fig13_by_liquidity_and_income_risk.do
*
* Figure 13: The debt-to-income response to monetary policy by liquidity,
* predicted unemployment risk and sector of employment
*   (a) liquid assets (deposits), quintiles
*   (b) comprehensive liquidity measure, quintiles
*   (c) predicted unemployment risk within the top debt-to-income quintile
*   (d) sector of employment
* All groups are defined in year t-1.
*
* The same estimates, with confidence bands, are shown in Figures B5-B8.
*
* Server output (in ${w5_tables}, .xlsx and .csv), rows stacked by group:
*   v3A_micro_LIQgroups_diff_deb_inc_r0_b1_c1_romer_iv         (5 groups)
*   v3A_micro_LIQSUBgroups_diff_deb_inc_r0_b1_c1_romer_iv      (5 groups)
*   v3A_micro_DTIUNEMP3groups_diff_deb_inc_r0_b1_c1_romer_iv   (10 groups, see below)
*   v3A_micro_sectorgroups_diff_deb_inc_r0_b1_c1_romer_iv      (9 groups, see below)
* Plotted by 3_local_matlab/fig13_by_liquidity_and_income_risk.m and figB5-figB8
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

global dependent_var deb_inc

********************************************************************************
* (a) liquid assets: quintiles of deposits at the beginning of the year

global group_type LIQ

gen liquid = l.deposits_a
egen group = xtile(liquid),  n(5) by(year)

do programs/lp_run.do groups

drop group liquid

********************************************************************************
* (b) comprehensive liquidity measure: income minus reference consumption (SIFO)
*     plus home equity above 30 percent of the house value plus deposits

global group_type LIQSUB

bys lnr: ipolate sifo_hh_expenses_a year, gen(sifo_hh_ipolate)
tsset lnr year

gen liquidSUB = l.income_total - l.sifo_hh_ipolate + (0.7*l.housing_wealth_a - l.debt_a)*(0.7*l.housing_wealth_a > l.debt_a) + l.deposits_a
egen group = xtile(liquidSUB),  n(5) by(year)

do programs/lp_run.do groups

drop group liquidSUB sifo_hh_ipolate

********************************************************************************
* (c) predicted unemployment risk (below/above the median within year) interacted
*     with the debt-to-income quintile:
*     groups 1-5  = low unemployment risk,  debt-to-income quintiles 1-5
*     groups 6-10 = high unemployment risk, debt-to-income quintiles 1-5
*     The figure shows groups 5 and 10 (top debt-to-income quintile).

global group_type DTIUNEMP3

egen group = group(dumUNEMP3 DTI_quintile_byyear)

do programs/lp_run.do groups

drop group

********************************************************************************
* (d) sector of employment of the main earner in year t-1:
*     1 manufacturing, 2 utilities, 3 construction, 4 wholesale, 5 transport,
*     6 accommodation, 7 financial, 8 public (incl. education and health), 9 other

global group_type sector

gen _temp = l.sector
egen group = group(_temp)
replace group = . if _temp == .

do programs/lp_run.do groups

drop group _temp
