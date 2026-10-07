%% fig14_ltv_and_net_debt.m
%
% Figure 14: Loan-to-value and net debt responses to monetary policy
%
% Input:  data/server_output/v3A_micro_all_diff_ltv_hou_r0_b1_c1_romer_iv.csv
%         data/server_output/v3A_micro_all_diff_ndeb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/fig14_ltv_and_net_debt.do)
% Output: results/figures/Figure14a.eps  loan-to-value
%         results/figures/Figure14b.eps  net debt-to-income

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


plot_irf_bands(read_lp('v3A_micro_all_diff_ltv_hou_r0_b1_c1_romer_iv'),  'Figure14a');
plot_irf_bands(read_lp('v3A_micro_all_diff_ndeb_inc_r0_b1_c1_romer_iv'), 'Figure14b');
