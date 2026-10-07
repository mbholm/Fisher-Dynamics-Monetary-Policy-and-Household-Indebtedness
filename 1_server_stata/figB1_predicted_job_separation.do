********************************************************************************
* figB1_predicted_job_separation.do
*
* Figure B1 (Online Appendix): The distribution of predicted job separation rates
*
* The predicted job separation rate (pred_unemp2) comes from a probit model estimated
* when the household panel is built. The vertical line marks the median. In the
* published figure the line was drawn at 5.14, the median at the time the figure
* was made; here the median is computed from the data in memory.
*
* The figure is drawn on the server; there is no Matlab step for this figure.
* Server output: ${w5_figures}/histogram_predicted_unemployment.eps
********************************************************************************

do 00_config.do

global shock_name romer
global robust 0

do programs/load_estimation_data.do

gen pred_unemp_graph = pred_unemp2*100

qui su pred_unemp_graph, d
local med = r(p50)
di "Median predicted job separation rate (percent): " %6.2f `med'

tw 	(hist pred_unemp_graph if pred_unemp_graph < 20, w(0.25) percent) ///
	(scatteri 0 `med' 4 `med', c(l) m(i) lc(black)), ///
	graphregion(color(white)) legend(off) xtitle("Predicted Job Separation Rate in %") ytitle("Population Share in %")
graph export ${w5_figures}/histogram_predicted_unemployment.eps, as(eps) preview(off) replace

tabstat pred_unemp2, by(dumUNEMP2) stat(mean)
