%% figB8_by_sector_bands.m
%
% Figure B8 (Online Appendix): Debt-to-income responses to monetary policy by sector of employment
%
% Input:  data/server_output/v3A_micro_sectorgroups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/figB8_by_sector_bands.do, which runs fig13_by_liquidity_and_income_risk.do)
% Output: results/figures/FigureB8a.eps  manufacturing
%         results/figures/FigureB8b.eps  construction
%         results/figures/FigureB8c.eps  public

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


est = read_lp('v3A_micro_sectorgroups_diff_deb_inc_r0_b1_c1_romer_iv');

plot_irf_bands(est(6*(1-1)+1 : 6*1, :), 'FigureB8a', 'YLim', [-5 1]);   % manufacturing
plot_irf_bands(est(6*(3-1)+1 : 6*3, :), 'FigureB8b', 'YLim', [-5 1]);   % construction
plot_irf_bands(est(6*(8-1)+1 : 6*8, :), 'FigureB8c', 'YLim', [-5 1]);   % public
