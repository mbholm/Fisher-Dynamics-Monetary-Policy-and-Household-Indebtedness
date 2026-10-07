%% figB6_by_comprehensive_liquidity_bands.m
%
% Figure B6 (Online Appendix): Debt-to-income responses to monetary policy by initial comprehensive liquidity measure
%
% Input:  data/server_output/v3A_micro_LIQSUBgroups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/figB6_by_comprehensive_liquidity_bands.do, which runs fig13_by_liquidity_and_income_risk.do)
% Output: results/figures/FigureB6a.eps  0-20%
%         results/figures/FigureB6b.eps  20-40%
%         results/figures/FigureB6c.eps  40-60%
%         results/figures/FigureB6d.eps  60-80%
%         results/figures/FigureB6e.eps  80-100%

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


est = read_lp('v3A_micro_LIQSUBgroups_diff_deb_inc_r0_b1_c1_romer_iv');

plot_irf_bands(est(6*(1-1)+1 : 6*1, :), 'FigureB6a');   % 0-20%
plot_irf_bands(est(6*(2-1)+1 : 6*2, :), 'FigureB6b');   % 20-40%
plot_irf_bands(est(6*(3-1)+1 : 6*3, :), 'FigureB6c');   % 40-60%
plot_irf_bands(est(6*(4-1)+1 : 6*4, :), 'FigureB6d');   % 60-80%
plot_irf_bands(est(6*(5-1)+1 : 6*5, :), 'FigureB6e');   % 80-100%
