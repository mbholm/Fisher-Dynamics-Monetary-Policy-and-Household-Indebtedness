%% figB5_by_liquid_assets_bands.m
%
% Figure B5 (Online Appendix): Debt-to-income responses to monetary policy by initial liquid assets
%
% Input:  data/server_output/v3A_micro_LIQgroups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/figB5_by_liquid_assets_bands.do, which runs fig13_by_liquidity_and_income_risk.do)
% Output: results/figures/FigureB5a.eps  0-20%
%         results/figures/FigureB5b.eps  20-40%
%         results/figures/FigureB5c.eps  40-60%
%         results/figures/FigureB5d.eps  60-80%
%         results/figures/FigureB5e.eps  80-100%

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


est = read_lp('v3A_micro_LIQgroups_diff_deb_inc_r0_b1_c1_romer_iv');

plot_irf_bands(est(6*(1-1)+1 : 6*1, :), 'FigureB5a');   % 0-20%
plot_irf_bands(est(6*(2-1)+1 : 6*2, :), 'FigureB5b');   % 20-40%
plot_irf_bands(est(6*(3-1)+1 : 6*3, :), 'FigureB5c');   % 40-60%
plot_irf_bands(est(6*(4-1)+1 : 6*4, :), 'FigureB5d');   % 60-80%
plot_irf_bands(est(6*(5-1)+1 : 6*5, :), 'FigureB5e');   % 80-100%
