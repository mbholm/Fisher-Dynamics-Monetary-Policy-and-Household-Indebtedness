%% fig06_dti_decomposition.m
%
% Figure 6: Decomposition of the debt-to-income response to monetary policy
%
% Input:  data/server_output/v3A_micro_all_dti_*_r0_b1_c1_romer_iv.csv
%         (1_server_stata/fig06_dti_decomposition.do)
% Output: results/figures/Figure06a.eps  nominal debt change
%         results/figures/Figure06b.eps  Fisher dynamics
%         results/figures/Figure06c.eps  non-interest income
%         results/figures/Figure06d.eps  net interest income

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


suffix = '_r0_b1_c1_romer_iv';

plot_irf_bands(read_lp(['v3A_micro_all_dti_debt_nom' suffix]),             'Figure06a');
plot_irf_bands(read_lp(['v3A_micro_all_dti_income_total_nom' suffix]),     'Figure06b');
plot_irf_bands(read_lp(['v3A_micro_all_dti_income_x_nintinc_nom' suffix]), 'Figure06c');
plot_irf_bands(read_lp(['v3A_micro_all_dti_income_nintinc_nom' suffix]),   'Figure06d');
