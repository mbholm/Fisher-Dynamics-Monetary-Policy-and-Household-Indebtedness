%% fig08_market_based_shocks.m
%
% Figure 8: Decomposition of the debt-to-income response to monetary policy using market-based shocks
%
% Input:  data/server_output/v3A_micro_all_*_r0_b1_c1_market_iv.csv
%         (1_server_stata/fig08_market_based_shocks.do)
% Output: results/figures/Figure08a.eps  debt-to-income change
%         results/figures/Figure08b.eps  nominal debt change
%         results/figures/Figure08c.eps  Fisher dynamics

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


suffix = '_r0_b1_c1_market_iv';

plot_irf_bands(read_lp(['v3A_micro_all_diff_deb_inc' suffix]),         'Figure08a');
plot_irf_bands(read_lp(['v3A_micro_all_dti_debt_nom' suffix]),         'Figure08b');
plot_irf_bands(read_lp(['v3A_micro_all_dti_income_total_nom' suffix]), 'Figure08c');
