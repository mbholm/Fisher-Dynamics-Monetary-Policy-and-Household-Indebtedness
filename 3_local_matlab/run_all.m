%% run_all.m
%
% Replication package for
%   Fagereng, A., M. A. H. Gulbrandsen, M. B. Holm, and G. J. Natvik,
%   "Fisher Dynamics, Monetary Policy, and Household Indebtedness",
%   Journal of Money, Credit and Banking (MS#23-328).
%
% Draws all figures that are made in Matlab from the files in the folder data
% and writes them to results/figures. Each figure file can also be run on its own.
%
% Figures 1-4 and B1 are drawn in Stata on Statistics Norway's server
% (see 1_server_stata); copies of those figures are in results/figures.
%
% Requirements: Matlab with the Statistics and Machine Learning Toolbox.
%               Figure B2 additionally requires the Econometrics Toolbox (function hac).

here = fileparts(mfilename('fullpath'));

files = {'fig05_dti_response', 'fig06_dti_decomposition', 'fig07_shock_series', ...
         'fig08_market_based_shocks', 'fig09_hikes_versus_cuts', 'fig10_by_initial_dti', ...
         'fig11_amortization_schedule', 'fig12_by_housing_tenure', ...
         'fig13_by_liquidity_and_income_risk', 'fig14_ltv_and_net_debt', ...
         'figA1_price_growth_distribution', 'figB2_macro_responses', ...
         'figB3_excluding_shocks_after_2008', 'figB4_by_initial_dti_bands', ...
         'figB5_by_liquid_assets_bands', 'figB6_by_comprehensive_liquidity_bands', ...
         'figB7_by_dti_and_unemployment_risk_bands', 'figB8_by_sector_bands'};

for ii = 1:numel(files)
    fprintf('Running %s\n', files{ii});
    run_one(fullfile(here, [files{ii} '.m']));
end

fprintf('All figures written to %s\n', fullfile(fileparts(here), 'results', 'figures'));

function run_one(file)
% run a figure file in its own workspace (the figure files start with "clear")
run(file);
close all;
end
