********************************************************************************
* figA1_household_price_indices.do
*
* Household-level consumer price indices (Online Appendix A, Figure A1).
*
* Computes average expenditure weights for 80 household groups (adults x children
* x age group x income quintile) from the Norwegian Consumer Expenditure Survey
* 2012 and combines them with consumer price indices at COICOP level 1 into
* group-specific price growth.
*
* Runs on a local computer (no confidential register data).
*
* Input:  Consumer Expenditure Survey 2012 microdata (NSD2103.dta). The file is
*         distributed by Sikt (Norwegian Agency for Shared Services in Education
*         and Research) and cannot be redistributed with this package. Set the
*         global survey2012 below to the location of the file.
*         data/cpi/cpi_coicop_annual.csv   Statistics Norway, table 03014:
*                                          CPI by consumption group (COICOP level 1)
* Output: data/cpi/hhgroup_expenditure_weights_2012.csv      expenditure weights by group
*         data/cpi/hhgroup_cpi_with_group_definitions.csv    price growth by group and year,
*                                                            with the group definitions; this
*                                                            file is taken to the server
*         data/cpi/hhgroup_cpi.csv                           price growth by group, 1993-2015;
*                                                            plotted in Figure A1 by
*                                                            3_local_matlab/figA1_price_growth_distribution.m
*
* Requires: asgen (ssc install asgen)
* Run from the folder 2_local_stata.
********************************************************************************

clear
set more off

* location of the Consumer Expenditure Survey 2012 microdata
if "${survey2012}" == "" global survey2012 "NSD2103.dta"

* package data folder and a folder for temporary files
if "${data}" == "" global data "../data"
if "${temp}" == "" global temp "."

use "${survey2012}", clear

gen adults = 1
replace adults = 2 if slekt2 == 2 | slekt2 == 3

gen kids = 0
replace kids = kids + 1 if slekt2 == 4
replace kids = kids + 1 if slekt3 == 4
replace kids = kids + 1 if slekt4 == 4
replace kids = kids + 1 if slekt5 == 4
replace kids = kids + 1 if slekt6 == 4
replace kids = kids + 1 if slekt7 == 4
replace kids = kids + 1 if slekt8 == 4
replace kids = kids + 1 if slekt9 == 4
replace kids = kids + 1 if slekt10 == 4

gen weight = fvekt

gen age = ald1
gen grossincome = aggi_24_2012 + aggi_21_2012
gen dispincome = aggi_24_2012 / adults
gen expenditure = sfutg_c

gen owner = 1 if efbolig == 1 | efbolig == 2
replace owner = 0 if owner == .

* make groups

replace kids = 1 if kids != 0
gen ageG = 1 if age < 30
replace ageG = 2 if age >= 30 & age < 40
replace ageG = 3 if age >= 40 & age < 50
replace ageG = 4 if age >= 50 & age < 60
replace ageG = 5 if age >= 60 & age < 70
replace ageG = 6 if age >= 70

replace kids = 0 if ageG >= 4 | ageG == 1

bys ageG (dispincome): gen incPerc = floor((_n-1)/_N*5)+1

egen hhGroup = group(adults kids ageG incPerc)
tab hhGroup



* expenditure shares

gen food_and_drink_01 = (cvnr_01111_belop+cvnr_01112_belop+cvnr_01113_belop+cvnr_01114_belop+cvnr_01115_belop+cvnr_01121_belop+cvnr_01122_belop+cvnr_01123_belop+cvnr_01124_belop+cvnr_01125_belop+cvnr_01126_belop+cvnr_01127_belop+cvnr_01131_belop+cvnr_01132_belop+cvnr_01133_belop+cvnr_01134_belop+cvnr_01141_belop+cvnr_01142_belop+cvnr_01143_belop+cvnr_01144_belop+cvnr_01145_belop+cvnr_01146_belop+cvnr_01147_belop+cvnr_01151_belop+cvnr_01152_belop+cvnr_01153_belop+cvnr_01154_belop+cvnr_01155_belop+cvnr_01161_belop+cvnr_01162_belop+cvnr_01163_belop+cvnr_01164_belop+cvnr_01165_belop+cvnr_01166_belop+cvnr_01167_belop+cvnr_01168_belop+cvnr_01169_belop+cvnr_01171_belop+cvnr_01172_belop+cvnr_01173_belop+cvnr_01174_belop+cvnr_01175_belop+cvnr_01176_belop+cvnr_01177_belop+cvnr_01178_belop+cvnr_01181_belop+cvnr_01182_belop+cvnr_01183_belop+cvnr_01184_belop+cvnr_01185_belop+cvnr_01186_belop+cvnr_01191_belop+cvnr_01192_belop+cvnr_01193_belop+cvnr_01194_belop+cvnr_01211_belop+cvnr_01212_belop+cvnr_01213_belop+cvnr_01221_belop+cvnr_01222_belop+cvnr_01223_belop+cvnr_01224_belop)/expenditure
gen alcohol_tobacco_02 = (cvnr_02111_belop+cvnr_02121_belop+cvnr_02122_belop+cvnr_02131_belop+cvnr_02211_belop+cvnr_02212_belop+cvnr_02213_belop)/expenditure
gen clothing_03 = (cvnr_03111_belop+cvnr_03121_belop+cvnr_03122_belop+cvnr_03123_belop+cvnr_03131_belop+cvnr_03141_belop+cvnr_03211_belop+cvnr_03212_belop+cvnr_03213_belop+cvnr_03221_belop)/expenditure
gen housing_04 = (cvnr_04111_belop+cvnr_04121_belop+cvnr_04211_belop+cvnr_04221_belop+cvnr_04311_belop+cvnr_04321_belop+cvnr_04411_belop+cvnr_04421_belop+cvnr_04431_belop+cvnr_04441_belop+cvnr_04511_belop+cvnr_04521_belop+cvnr_04522_belop+cvnr_04531_belop+cvnr_04541_belop+cvnr_04551_belop)/expenditure
gen furniture_05 = (cvnr_05111_belop+cvnr_05121_belop+cvnr_05131_belop+cvnr_05211_belop+cvnr_05311_belop+cvnr_05312_belop+cvnr_05313_belop+cvnr_05314_belop+cvnr_05315_belop+cvnr_05316_belop+cvnr_05317_belop+cvnr_05321_belop+cvnr_05331_belop+cvnr_05411_belop+cvnr_05412_belop+cvnr_05413_belop+cvnr_05414_belop+cvnr_05511_belop+cvnr_05521_belop+cvnr_05611_belop+cvnr_05612_belop+cvnr_05621_belop+cvnr_05622_belop)/expenditure
gen health_06 = (cvnr_06111_belop+cvnr_06121_belop+cvnr_06131_belop+cvnr_06211_belop+cvnr_06221_belop+cvnr_06231_belop+cvnr_06232_belop+cvnr_06233_belop+cvnr_06311_belop)/expenditure
gen transport_07 = (cvnr_07111_belop+cvnr_07112_belop+cvnr_07121_belop+cvnr_07131_belop+cvnr_07141_belop+cvnr_07211_belop+cvnr_07221_belop+cvnr_07231_belop+cvnr_07241_belop+cvnr_07311_belop+cvnr_07321_belop+cvnr_07331_belop+cvnr_07341_belop+cvnr_07351_belop+cvnr_07361_belop)/expenditure
gen post_08 = (cvnr_08111_belop+cvnr_08211_belop+cvnr_08311_belop)/expenditure
gen culture_09 = (cvnr_09111_belop+cvnr_09112_belop+cvnr_09121_belop+cvnr_09122_belop+cvnr_09131_belop+cvnr_09141_belop+cvnr_09151_belop+cvnr_09211_belop+cvnr_09221_belop+cvnr_09222_belop+cvnr_09231_belop+cvnr_09311_belop+cvnr_09321_belop+cvnr_09331_belop+cvnr_09341_belop+cvnr_09351_belop+cvnr_09411_belop+cvnr_09421_belop+cvnr_09422_belop+cvnr_09423_belop+cvnr_09424_belop+cvnr_09431_belop+cvnr_09511_belop+cvnr_09521_belop+cvnr_09531_belop+cvnr_09541_belop+cvnr_09611_belop)/expenditure
gen education_10 = (cvnr_10111_belop+cvnr_10211_belop+cvnr_10311_belop+cvnr_10411_belop+cvnr_10511_belop)/expenditure
gen hotel_11 = (cvnr_11111_belop+cvnr_11112_belop+cvnr_11121_belop+cvnr_11211_belop)/expenditure
gen other_12 = (cvnr_12111_belop+cvnr_12121_belop+cvnr_12131_belop+cvnr_12311_belop+cvnr_12321_belop+cvnr_12322_belop+cvnr_12411_belop+cvnr_12521_belop+cvnr_12531_belop+cvnr_12541_belop+cvnr_12551_belop+cvnr_12621_belop+cvnr_12711_belop)/expenditure

keep adults kids ageG incPerc age grossincome dispincome owner food_and_drink_01 alcohol_tobacco_02 clothing_03 housing_04 furniture_05 health_06 transport_07 post_08 culture_09 education_10 hotel_11 other_12 weight expenditure hhGroup 

bys hhGroup: asgen w_01 = food_and_drink_01, w(weight)
bys hhGroup: asgen w_02 = alcohol_tobacco_02, w(weight)
bys hhGroup: asgen w_03 = clothing_03, w(weight)
bys hhGroup: asgen w_04 = housing_04, w(weight)
bys hhGroup: asgen w_05 = furniture_05, w(weight)
bys hhGroup: asgen w_06 = health_06, w(weight)
bys hhGroup: asgen w_07 = transport_07, w(weight)
bys hhGroup: asgen w_08 = post_08, w(weight)
bys hhGroup: asgen w_09 = culture_09, w(weight)
bys hhGroup: asgen w_10 = education_10, w(weight)
bys hhGroup: asgen w_11 = hotel_11, w(weight)
bys hhGroup: asgen w_12 = other_12, w(weight)

bys hhGroup: keep if _n == 1



save "${temp}/data_2012.dta", replace


keep hhGroup w_*
save "${temp}/hhgroup_weight_2012.dta", replace
export delimited using "${data}/cpi/hhgroup_expenditure_weights_2012.csv", replace




** get cpi numbers
import delimited using "${data}/cpi/cpi_coicop_annual.csv", clear varnames(1)
save "${temp}/cpi_cleaned.dta", replace

clear
** make dummy data with hhgroups x year
gen year = 1980
gen hhGroup = 1
set obs `=_N + 3600'

replace hhGroup = mod(_n-1,80)+1
sort hhGroup
bys hhGroup: replace year = 1979+_n-1
sort year hhGroup

merge m:1 hhGroup using "${temp}/hhgroup_weight_2012.dta", nogen keep(match master)
merge m:1 year using "${temp}/cpi_cleaned.dta", nogen keep(match master)

gen p_index = w_01*p_01 + w_02*p_02 + w_03*p_03 + w_04*p_04 + w_05*p_05 + w_06*p_06 + w_07*p_07 + w_08*p_08 + w_09*p_09 + w_10*p_10 + w_11*p_11 + w_12*p_12
tsset hhGroup year

gen test = w_01 + w_02 + w_03 + w_04 + w_05 + w_06 + w_07 + w_08 + w_09 + w_10 + w_11 + w_12

gen p_growth_group = (p_index / l.p_index - 1)*100

tabstat p_growth_group, by(year) stat(min p10 p50 p90 mean max)

keep year hhGroup p_growth_group 
merge m:1 hhGroup using "${temp}/data_2012.dta", nogen keep(match master) keepusing(adults kids ageG incPerc)

keep if year >= 1993

save "${temp}/hhgroup_cpi.dta", replace

* file that is uploaded to the server (merged onto households in 1_server_stata/prep)
export delimited year hhGroup p_growth_group adults kids ageG incPerc using "${data}/cpi/hhgroup_cpi_with_group_definitions.csv", replace

keep if year >= 1993 & year <= 2015

* file behind Figure A1
export delimited year hhGroup p_growth_group using "${data}/cpi/hhgroup_cpi.csv", replace

tabstat p_growth_group, by(year) stat(p25 p50 p75)
gen p25 = .
gen p75 = .
forval yy = 1993/2015 {
	qui	su p_growth_group if year == `yy', d
	replace p25 = r(p25) if year == `yy'
	replace p75 = r(p75) if year == `yy'
}
gen temp = p75-p25
tabstat temp, by(year)
