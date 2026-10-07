%% figB3_excluding_shocks_after_2008.m
%
% Figure B3 (Online Appendix): Decomposition of the debt-to-income response to monetary policy. Robustness to excluding monetary policy shocks after 2008.
%
% Input:  data/server_output/v3A_micro_all_*_r1_b1_c1_romer_iv.csv
%         (1_server_stata/figB3_excluding_shocks_after_2008.do)
% Output: results/figures/FigureB3a.eps  debt-to-income change
%         results/figures/FigureB3b.eps  nominal debt change
%         results/figures/FigureB3c.eps  Fisher dynamics

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


suffix = '_r1_b1_c1_romer_iv';

plot_irf_bands(read_lp(['v3A_micro_all_diff_deb_inc' suffix]),         'FigureB3a');
plot_irf_bands(read_lp(['v3A_micro_all_dti_debt_nom' suffix]),         'FigureB3b');
plot_irf_bands(read_lp(['v3A_micro_all_dti_income_total_nom' suffix]), 'FigureB3c');
