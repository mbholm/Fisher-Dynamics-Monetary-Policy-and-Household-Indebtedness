********************************************************************************
* 00_config.do
*
* Replication package for
*   Fagereng, A., M. A. H. Gulbrandsen, M. B. Holm, and G. J. Natvik,
*   "Fisher Dynamics, Monetary Policy, and Household Indebtedness",
*   Journal of Money, Credit and Banking (MS#23-328).
*
* Paths and settings shared by all do-files that run on Statistics Norway's
* server. Every table/figure do-file starts by running this file, so the only
* thing that has to be adapted to a new environment is the block of paths below.
*
* A global that is already defined is NOT overwritten. This makes it possible to
* redirect all paths from a wrapper script without editing this file.
*
* Required user-written commands (ssc install ...):
*   xtivreg2, ivreg2, ranktest   IV panel regressions with Driscoll-Kraay errors
*   estout                       eststo / esttab
*   egenmore                     egen ... = xtile()
*   outtable                     LaTeX export of the summary-statistics matrix
********************************************************************************

set more off

********************************************************************************
* paths

* folder holding this replication code (the folder this file is in)
if "${w5_prog}"    == "" global w5_prog    "<path to this folder on the server>"

* analysis data: the household panel (see README, Section 2)
if "${w5_data}"    == "" global w5_data    "<path to the folder with the household panel>"

* output: estimates (xlsx + csv), tables, log files, figures, temporary files
if "${w5_tables}"  == "" global w5_tables  "<path to the output folder>"
if "${w5_log}"     == "" global w5_log     "${w5_tables}/log"
if "${w5_figures}" == "" global w5_figures "${w5_tables}/figures"
if "${w5_temp}"    == "" global w5_temp    "${w5_tables}/temp"

* education register (used by table01_summary_statistics.do)
if "${w5_raw}"      == "" global w5_raw      "<path to the folder with the education register>"

* create the output folders if they do not exist
foreach dir in "${w5_tables}" "${w5_log}" "${w5_figures}" "${w5_temp}" {
	capture mkdir "`dir'"
}

cd "${w5_prog}"

********************************************************************************
* estimation settings (identical for all impulse responses in the paper)

* prefix of all output files
global version v3A

* highest horizon of the local projections (h = 0,1,...,NN)
global NN 5

* number of lags of the shock included as controls
global sLag 3

* additional controls (none)
global demogr_controls

* estimation sample: "" = all households ("_s1", "_s5", "_s20" = 1, 5, 20 percent random samples)
global sample

* balanced sample across horizons (1 = yes)
global balance 1

* sample restriction on imputed consumption (1 = sample_C1, used throughout the paper)
global csample 1

* all impulse responses are IV local projections
global iv _iv

* maximum lag in the Driscoll-Kraay standard errors
global DK_lag 2

* print regression tables in the log (0: no, 1: yes)
global show_output 1

********************************************************************************
* program: write the local-projection estimates as comma-separated text
* (one row per horizon; columns: estimate, standard error, observations)

capture program drop write_lp_csv
program define write_lp_csv
	args filename
	tempname fh
	file open `fh' using "`filename'", write text replace
	local R = rowsof(res)
	forvalues r = 1/`R' {
		local b  = strtrim(string(res[`r',1],   "%21.15g"))
		local se = strtrim(string(seRes[`r',1], "%21.15g"))
		local n  = strtrim(string(NObs[`r',1],  "%15.0f"))
		file write `fh' "`b',`se',`n'" _n
	}
	file close `fh'
end
