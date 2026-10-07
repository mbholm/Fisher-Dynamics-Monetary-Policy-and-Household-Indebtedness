********************************************************************************
* fig11_amortization_schedule.do
*
* Figure 11: Share of households whose debt deviates from a hypothetical
* amortization schedule, by time since house purchase
*
* The variables time (years since the household moved) and deviate (debt
* deviates by more than 15 percent from a 25-year annuity loan with a 2.5 percent
* interest rate) are constructed when the household panel is built.
*
* Server output: ${w5_tables}/mortgage_deviation.csv (columns: time, meanDev)
* Plotted by 3_local_matlab/fig11_amortization_schedule.m
********************************************************************************

do 00_config.do

cap log close
log using ${w5_log}/${version}_mortgage_deviation_c${csample}.log, replace

clear
u lnr year time deviate sample2 sample_C1 using ${w5_data}/households_cpi_9315${sample}

keep if sample2 == 1
keep if sample_C1 == 1

keep if deviate != .
bys time: egen meanDev = mean(deviate)
bys time: keep if _n == 1

list time meanDev

outsheet time meanDev using ${w5_tables}/mortgage_deviation.csv, c replace

log close
