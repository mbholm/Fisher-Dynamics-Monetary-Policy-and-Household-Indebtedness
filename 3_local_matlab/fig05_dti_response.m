%% fig05_dti_response.m
%
% Figure 5: The debt-to-income response to monetary policy
%
% Input:  data/server_output/v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/fig05_dti_response.do)
% Output: results/figures/Figure05.eps

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


plot_irf_bands(read_lp('v3A_micro_all_diff_deb_inc_r0_b1_c1_romer_iv'), 'Figure05');
