%% fig09_hikes_versus_cuts.m
%
% Figure 9: The debt-to-income response to interest rate hikes and cuts
%
% Input:  data/server_output/v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv_pos.csv
%         data/server_output/v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv_neg.csv
%         (1_server_stata/fig09_hikes_versus_cuts.do)
% Output: results/figures/Figure09a.eps  interest rate hikes only
%         results/figures/Figure09b.eps  interest rate cuts only

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


plot_irf_bands(read_lp('v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv_pos'), 'Figure09a');
plot_irf_bands(read_lp('v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv_neg'), 'Figure09b');
