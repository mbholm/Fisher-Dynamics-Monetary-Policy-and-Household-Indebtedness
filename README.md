# Replication package

Fagereng, A., M. A. H. Gulbrandsen, M. B. Holm, and G. J. Natvik.
"Fisher Dynamics, Monetary Policy, and Household Indebtedness."
*Journal of Money, Credit and Banking* (MS#23-328).

This package contains all programs behind the tables and figures in the paper
and its online appendix, the data that can be shared, and the estimates that
were exported from the secure server where the household data are stored.


## 1. Overview

The paper uses administrative microdata on the universe of Norwegian
households. These data are confidential and can only be used on Statistics
Norway's server (see Section 2). The work is therefore split in two steps.

1. **On the server (Stata).** The folder `1_server_stata` contains one do-file per
   table and figure, which run on the household panel built from the
   registers (the code that builds the panel is not included, see Section 2). Figures 1-4 and B1 are
   drawn directly on the server. For the impulse-response figures the do-files
   write the estimates (point estimate, standard error, number of
   observations for each horizon) to small files that can be taken out of the
   server.
2. **On a local computer (Matlab).** The folder `3_local_matlab` contains one
   file per figure. Each file reads the exported estimates in
   `data/server_output` and draws the figure. Figures 7, A1, and B2 only use
   public data and are produced entirely on a local computer.

Everything in step 2 can be replicated with the files in this package. Step 1
requires access to the microdata.

The journal has waived the data archiving requirement for the confidential
microdata.


## 2. Data availability

### Confidential data (not included)

The household-level data come from administrative registers held by Statistics
Norway: tax records with income and balance sheets, the population register
with household composition and addresses, the education register, and
employer-employee records. The data cover 1993-2015 and are stored on
Statistics Norway's server.

Researchers at approved research institutions can apply to Statistics Norway
for access to the same registers (https://www.ssb.no/en/data-til-forskning).
Access requires an approved project and is subject to a fee. The authors will
assist researchers who obtain access with the details of the data
construction.

The household panel builds on the data set constructed for Holm, Paul, and
Tischbirek (2021). The code that builds the panel from the registers is not
included in the package; the authors will share it with researchers who
obtain access to the data.

The Norwegian Consumer Expenditure Survey 2012, used to compute expenditure
weights by household group, is distributed by Sikt (https://sikt.no) and
cannot be redistributed. The program that uses it and the resulting
group-level weights and price indices are included.

The high-frequency interest rate surprises around Norges Bank's policy
announcements, from which the market-based monetary policy shocks are
constructed, are from Brubakk, ter Ellen, Robstad, and Xu (2022) and are not
included. They can be requested from those authors. The program that uses
them and the resulting annual shock series are included.

### Data included in this package (all files are plain text)

| Folder / file | Content | Source |
|---|---|---|
| `data/server_output/v3A_micro_*.csv` | Local-projection estimates exported from the server. One row per horizon 0-5 (stacked by household group where relevant); columns: estimate, standard error, observations. | Authors' estimates on the confidential data |
| `data/server_output/logs/` | Stata log files of the server run (October 2026) that produced the estimates, Table 1, and the server-drawn figures in this package. | Authors |
| `data/server_output/mortgage_deviation.csv` | Share of households deviating from a hypothetical amortization schedule, by years since house purchase. | Authors' calculations on the confidential data |
| `data/server_output/summary_stats_c1.tex` | Summary statistics (Table 1). | Authors' calculations on the confidential data |
| `data/monetary_policy_shocks/narrative_shocks_meeting.csv`, `narrative_shocks_annual.csv` | Narrative monetary policy shocks for Norway, by policy meeting and by year (percentage points). | Holm, Paul, and Tischbirek (2021) |
| `data/monetary_policy_shocks/policy_decisions.csv` | Dates of Norges Bank's policy decisions and the key policy rate. | Norges Bank; collected by Holm, Paul, and Tischbirek (2021) |
| `data/monetary_policy_shocks/market_shocks_annual.csv` | Market-based monetary policy shocks, annual (percentage points). | Constructed by `3_local_matlab/market_shocks/construct_market_based_shocks.m` from the high-frequency interest rate surprises of Brubakk, ter Ellen, Robstad, and Xu (2022) |
| `data/macro/macro_annual.csv`, `macro_quarterly.csv` | Policy rate, real GDP, consumer prices (CPI-AEL), investment, wages, unemployment. Sources are listed in `data/macro/SOURCES.txt`. | Statistics Norway and Norges Bank; collected by Holm, Paul, and Tischbirek (2021) |
| `data/macro/api_download/` | A new download (October 2026) of the same macro series, created by `3_local_matlab/download_macro_data.m`. Not used in the paper. | Statistics Norway, Norges Bank, and FRED |
| `data/cpi/cpi_coicop_annual.csv` | Consumer price index by consumption group (COICOP level 1), annual. | Statistics Norway, table 03014 |
| `data/cpi/hhgroup_expenditure_weights_2012.csv` | Average expenditure weights for 80 household groups. | Constructed by `2_local_stata/figA1_household_price_indices.do` |
| `data/cpi/hhgroup_cpi_with_group_definitions.csv`, `hhgroup_cpi.csv` | Price growth by household group and year. | Constructed by `2_local_stata/figA1_household_price_indices.do` |


## 3. Software

- **Stata** (version 16 or later) with the user-written commands `xtivreg2`,
  `ivreg2`, `ranktest`, `estout`, `egenmore`, `outtable` (server) and `asgen`
  (local). All are available from SSC (`ssc install <name>`).
- **Matlab** with the Statistics and Machine Learning Toolbox and the
  Econometrics Toolbox (function `hac`, used for Figure B2). The Matlab files
  were tested with release R2025b. The helper functions `rgb.m`, `tightfig.m`,
  and `ciplot_adj.m` in `3_local_matlab/functions` are third-party functions
  from the Matlab File Exchange.


## 4. Instructions

### Step 1: server (requires the confidential data)

1. Copy the folder `1_server_stata` to the server, and copy
   `data/cpi/hhgroup_cpi_with_group_definitions.csv` and
   `data/monetary_policy_shocks/market_shocks_annual.csv` to the data folder on
   the server.
2. Set the paths at the top of `00_config.do`.
3. Make `1_server_stata` the working directory and run `run_all.do`, or run the
   do-file of a single table or figure. Every table/figure do-file is
   self-contained: it reads the household panel and writes its output to the folders set in `00_config.do`.
4. Export the files listed in each do-file's header and place the `.csv` files
   in `data/server_output`.

The impulse-response do-files take between a few minutes and several hours
each on the full data (about 48 million household-year observations).

### Step 2: local computer

1. (Optional; needs the Consumer Expenditure Survey 2012.) Run
   `2_local_stata/figA1_household_price_indices.do` to re-create the files in
   `data/cpi`.
2. (Optional; needs the high-frequency surprises of Brubakk et al., see
   Section 2.) Run `3_local_matlab/market_shocks/construct_market_based_shocks.m`
   to re-create `data/monetary_policy_shocks/market_shocks_annual.csv`.
3. (Optional; needs an internet connection.) Run `3_local_matlab/download_macro_data.m`
   to download the macro series from Statistics Norway, Norges Bank, and FRED
   into `data/macro/api_download`. The files used in the paper are not
   overwritten: real GDP, investment, and wages have been revised and rebased
   since they were downloaded in 2021, while the policy rate, CPI-AEL, and the
   unemployment rate are unchanged.
4. Run `3_local_matlab/run_all.m`, or the file of a single figure. The figures
   are written to `results/figures`. The Matlab files find the package folders
   from their own location, so no paths have to be set. Running all files takes
   about one minute.


## 5. List of tables and figures

"Server" files are in `1_server_stata`, "Matlab" files in `3_local_matlab`.
Output files are in `results/figures` unless stated otherwise.

### Main text

| Exhibit | Server (Stata) | Local (Matlab) | Output |
|---|---|---|---|
| Table 1 | `table01_summary_statistics.do` | none | `results/tables/Table01_summary_stats_c1.tex` (first six columns) |
| Figure 1 | `fig01_decomposition_average.do` | none (drawn on the server) | `Figure01a.eps`, `Figure01b.eps` |
| Figure 2 | `fig02_decomposition_quintiles.do` | none (drawn on the server) | `Figure02a.eps` to `Figure02f.eps` |
| Figure 3 | `fig03_decomposition_movers_stayers.do` | none (drawn on the server) | `Figure03a.eps`, `Figure03b.eps` |
| Figure 4 | `fig04_contribution_movers_stayers.do` | none (drawn on the server) | `Figure04a.eps`, `Figure04b.eps` |
| Figure 5 | `fig05_dti_response.do` | `fig05_dti_response.m` | `Figure05.eps` |
| Figure 6 | `fig06_dti_decomposition.do` | `fig06_dti_decomposition.m` | `Figure06a.eps` to `Figure06d.eps` |
| Figure 7 | none (public data) | `fig07_shock_series.m` | `Figure07.eps` |
| Figure 8 | `fig08_market_based_shocks.do` | `fig08_market_based_shocks.m` | `Figure08a.eps` to `Figure08c.eps` |
| Figure 9 | `fig09_hikes_versus_cuts.do` | `fig09_hikes_versus_cuts.m` | `Figure09a.eps`, `Figure09b.eps` |
| Figure 10 | `fig10_by_initial_dti.do` | `fig10_by_initial_dti.m` | `Figure10a.eps` to `Figure10c.eps` (and `.png`) |
| Figure 11 | `fig11_amortization_schedule.do` | `fig11_amortization_schedule.m` | `Figure11.eps` |
| Figure 12 | `fig12_by_housing_tenure.do` | `fig12_by_housing_tenure.m` | `Figure12a.eps`, `Figure12b.eps` |
| Figure 13 | `fig13_by_liquidity_and_income_risk.do` | `fig13_by_liquidity_and_income_risk.m` | `Figure13a.eps` to `Figure13d.eps` (and `.png`) |
| Figure 14 | `fig14_ltv_and_net_debt.do` | `fig14_ltv_and_net_debt.m` | `Figure14a.eps`, `Figure14b.eps` |

The first-stage F statistics quoted in Sections 4.1 and 4.2 are written to the
log files of `fig05_dti_response.do` and `fig08_market_based_shocks.do`.

### Online appendix

| Exhibit | Server (Stata) | Local | Output |
|---|---|---|---|
| Figure A1 | none (public data) | `2_local_stata/figA1_household_price_indices.do`, then `figA1_price_growth_distribution.m` | `FigureA1.eps` |
| Figure B1 | `figB1_predicted_job_separation.do` | none (drawn on the server) | `FigureB1.eps` |
| Figure B2 | none (public data) | `figB2_macro_responses.m` | `FigureB2a.eps` to `FigureB2c.eps` |
| Figure B3 | `figB3_excluding_shocks_after_2008.do` | `figB3_excluding_shocks_after_2008.m` | `FigureB3a.eps` to `FigureB3c.eps` |
| Figure B4 | `figB4_by_initial_dti_bands.do` | `figB4_by_initial_dti_bands.m` | `FigureB4a.eps` to `FigureB4c.eps` |
| Figure B5 | `figB5_by_liquid_assets_bands.do` | `figB5_by_liquid_assets_bands.m` | `FigureB5a.eps` to `FigureB5e.eps` |
| Figure B6 | `figB6_by_comprehensive_liquidity_bands.do` | `figB6_by_comprehensive_liquidity_bands.m` | `FigureB6a.eps` to `FigureB6e.eps` |
| Figure B7 | `figB7_by_dti_and_unemployment_risk_bands.do` | `figB7_by_dti_and_unemployment_risk_bands.m` | `FigureB7a.eps`, `FigureB7b.eps` |
| Figure B8 | `figB8_by_sector_bands.do` | `figB8_by_sector_bands.m` | `FigureB8a.eps` to `FigureB8c.eps` |

Figures B4-B8 show, with confidence bands, estimates that also appear in
Figures 10 and 13. Their server do-files run the do-file of the corresponding
main-text figure unless the estimates already exist.


## 6. Folder structure

```
README.md
1_server_stata/
    00_config.do                 paths and estimation settings
    run_all.do                   runs all server files
    programs/                    code shared by the figure do-files
        load_estimation_data.do  loads the panel, selects the shock series
        lp_run.do                selects the local projection for an outcome
        lp_all_*.do              local projections, all households
        lp_groups_*.do           local projections by household group
        collapse_movers_stayers.do
    table01_*.do, fig01_*.do, ..., figB8_*.do    one file per table/figure
2_local_stata/
    figA1_household_price_indices.do
3_local_matlab/
    run_all.m                    runs all Matlab files
    download_macro_data.m        downloads the macro series from their sources
    fig05_*.m, ..., figB8_*.m    one file per figure
    functions/                   shared plotting and helper functions
    market_shocks/               construction of the market-based shocks
data/                            see Section 2
results/
    figures/                     all figures of the paper and online appendix
    tables/                      Table 1
```


## 7. Notes

- All server output in this package (estimates, Table 1, Figures 1-4 and B1,
  the data behind Figure 11, and the log files) comes from one run of the
  package's do-files on Statistics Norway's server in October 2026, and all
  figures in the published version of the paper are the files in
  `results/figures`.
- All figures are drawn so that they can be read in black and white. In
  Figures 1(b) and 2(f) the fill for interest income in the files from the
  server run was lightened from gs6 to gs12, the shade the do-files now use.
- Compared with the programs that produced the published results, the code has
  been reorganized into one file per figure, file paths have been collected in
  `00_config.do`, and the local projections additionally write their output as
  `.csv` and report the first-stage F statistic. The estimation code itself is
  unchanged.
- Figure B2 uses the macro data as downloaded in 2021
  (`data/macro/macro_annual.csv`). These files reproduce the published figure
  exactly and are the ones the package uses. A new download of the same
  series (`3_local_matlab/download_macro_data.m`, October 2026) gives
  identical responses of the policy rate and of consumer prices. The response
  of real GDP differs slightly, because the national accounts have been
  revised and rebased since 2021: the point estimates change by at most 0.1
  percentage points (for example, -1.96 instead of -2.06 percent four years
  after the shock) and the standard errors by at most 0.04. The household
  impulse responses in the paper do not use these macro series.


## References

Brubakk, L., S. ter Ellen, O. Robstad, and H. Xu (2022). "The Macroeconomic
Effects of Forward Communication." *Journal of International Money and
Finance*, 120, 102536.

Holm, M. B., P. Paul, and A. Tischbirek (2021). "The Transmission of Monetary
Policy under the Microscope." *Journal of Political Economy*, 129(10),
2861-2904.
