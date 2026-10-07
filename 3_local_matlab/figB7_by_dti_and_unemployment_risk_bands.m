%% figB7_by_dti_and_unemployment_risk_bands.m
%
% Figure B7 (Online Appendix): Debt-to-income responses to monetary policy by initial debt-to-income and unemployment risk
%
% The server file stacks 10 groups: unemployment-risk group (2) x debt-to-income
% quintile (5). Group 5 is low and group 10 is high unemployment risk in the top quintile.
%
% Input:  data/server_output/v3A_micro_DTIUNEMP3groups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/figB7_by_dti_and_unemployment_risk_bands.do, which runs fig13_by_liquidity_and_income_risk.do)
% Output: results/figures/FigureB7a.eps  low unemployment risk & top 20% of debt-to-income (group 5)
%         results/figures/FigureB7b.eps  high unemployment risk & top 20% of debt-to-income (group 10)

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


est = read_lp('v3A_micro_DTIUNEMP3groups_diff_deb_inc_r0_b1_c1_romer_iv');

plot_irf_bands(est(6*(5-1)+1 : 6*5, :), 'FigureB7a');   % low unemployment risk & top 20% of debt-to-income (group 5)
plot_irf_bands(est(6*(10-1)+1 : 6*10, :), 'FigureB7b');   % high unemployment risk & top 20% of debt-to-income (group 10)
