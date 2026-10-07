********************************************************************************
* run_all.do
*
* Replication package for
*   Fagereng, A., M. A. H. Gulbrandsen, M. B. Holm, and G. J. Natvik,
*   "Fisher Dynamics, Monetary Policy, and Household Indebtedness",
*   Journal of Money, Credit and Banking (MS#23-328).
*
* Runs everything that uses the confidential household microdata on Statistics
* Norway's server. Set the paths in 00_config.do, make the folder that contains
* this file the working directory, and run this file. Each table/figure do-file
* can also be run on its own.
*
* Figures 1-4 and B1 are drawn on the server. For all other figures the server
* produces the estimates (xlsx and csv), which are plotted by the Matlab files in
* 3_local_matlab. Figures 7, A1, and B2 do not use the microdata and have no
* server code.
********************************************************************************

do 00_config.do

********************************************************************************
* data preparation

* The do-files that build the household panel from the registers are not part
* of the package (see README, Section 2). The do-files below read the panel
* from the data folder set in 00_config.do.

********************************************************************************
* main text

do table01_summary_statistics.do

do fig01_decomposition_average.do
do fig02_decomposition_quintiles.do
do fig03_decomposition_movers_stayers.do
do fig04_contribution_movers_stayers.do
do fig05_dti_response.do
do fig06_dti_decomposition.do
* Figure 7 (monetary policy shock series): no microdata, see 3_local_matlab/fig07_shock_series.m
do fig08_market_based_shocks.do
do fig09_hikes_versus_cuts.do
do fig10_by_initial_dti.do
do fig11_amortization_schedule.do
do fig12_by_housing_tenure.do
do fig13_by_liquidity_and_income_risk.do
do fig14_ltv_and_net_debt.do

********************************************************************************
* online appendix

* Figure A1 (price growth across groups): no microdata, see 2_local_stata and 3_local_matlab
do figB1_predicted_job_separation.do
* Figure B2 (macro responses): no microdata, see 3_local_matlab/figB2_macro_responses.m
do figB3_excluding_shocks_after_2008.do
do figB4_by_initial_dti_bands.do
do figB5_by_liquid_assets_bands.do
do figB6_by_comprehensive_liquidity_bands.do
do figB7_by_dti_and_unemployment_risk_bands.do
do figB8_by_sector_bands.do
