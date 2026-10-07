********************************************************************************
* lp_run.do
*
* Runs the local projection that belongs to the outcome in $dependent_var.
*
* Usage:  do programs/lp_run.do all            all households jointly
*         do programs/lp_run.do all pos        only interest rate hikes as instrument
*         do programs/lp_run.do all neg        only interest rate cuts as instrument
*         do programs/lp_run.do groups         separately for each value of "group"
*
* Outcomes and specifications (see Section 4.1 of the paper):
*   deb_inc, ndeb_inc, ltv_hou     change in the ratio between t-1 and t+h
*   debt_nom                       nominal debt change relative to income in t-1
*   income_*_nom                   Fisher dynamics: DTI in t+h times the change in the
*                                  income component relative to income in t-1
********************************************************************************

args scope variant

local xx "${dependent_var}"

local is_ratio  = inlist("`xx'", "deb_inc", "ndeb_inc", "ndeb2_inc", "ltv_hou")
local is_debt   = "`xx'" == "debt_nom"
local is_income = inlist("`xx'", "income_total_nom", "income_x_nintinc_nom", "income_nintinc_nom")

if `is_ratio' + `is_debt' + `is_income' != 1 {
	di as error "lp_run.do: no local projection defined for dependent variable `xx'"
	exit 198
}
if !inlist("`scope'", "all", "groups") {
	di as error "lp_run.do: first argument must be all or groups"
	exit 198
}
if "`variant'" != "" & !("`scope'" == "all" & `is_ratio' & inlist("`variant'", "pos", "neg")) {
	di as error "lp_run.do: pos/neg is only available for ratios estimated on all households"
	exit 198
}

if "`scope'" == "all" {
	if `is_ratio' & "`variant'" == ""    do programs/lp_all_diff.do
	if `is_ratio' & "`variant'" == "pos" do programs/lp_all_diff_pos.do
	if `is_ratio' & "`variant'" == "neg" do programs/lp_all_diff_neg.do
	if `is_debt'                         do programs/lp_all_dti_debt.do
	if `is_income'                       do programs/lp_all_dti.do
}

if "`scope'" == "groups" {
	if `is_ratio'                        do programs/lp_groups_diff.do
	if `is_debt'                         do programs/lp_groups_dti_debt.do
	if `is_income'                       do programs/lp_groups_dti.do
}
