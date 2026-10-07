%% figB4_by_initial_dti_bands.m
%
% Figure B4 (Online Appendix): Debt-to-income responses to monetary policy by initial debt-to-income
%
% Input:  data/server_output/v3A_micro_DTI622groups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/figB4_by_initial_dti_bands.do, which runs fig10_by_initial_dti.do)
% Output: results/figures/FigureB4a.eps  bottom 60%
%         results/figures/FigureB4b.eps  60-80%
%         results/figures/FigureB4c.eps  top 20%

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


est = read_lp('v3A_micro_DTI622groups_diff_deb_inc_r0_b1_c1_romer_iv');

plot_irf_bands(est(6*(1-1)+1 : 6*1, :), 'FigureB4a');   % bottom 60%
plot_irf_bands(est(6*(2-1)+1 : 6*2, :), 'FigureB4b');   % 60-80%
plot_irf_bands(est(6*(3-1)+1 : 6*3, :), 'FigureB4c');   % top 20%
