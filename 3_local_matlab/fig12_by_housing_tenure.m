%% fig12_by_housing_tenure.m
%
% Figure 12: The debt-to-income response to monetary policy by housing tenure
%
% Groups: 1 = recent movers (moved within the two years before the shock),
%         2 = non-recent movers.
%
% Input:  data/server_output/v3A_micro_recMovgroups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         (1_server_stata/fig12_by_housing_tenure.do)
% Output: results/figures/Figure12a.eps  recent movers
%         results/figures/Figure12b.eps  non-recent movers

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


est = read_lp('v3A_micro_recMovgroups_diff_deb_inc_r0_b1_c1_romer_iv');

plot_irf_bands(est(1:6,  :), 'Figure12a');
plot_irf_bands(est(7:12, :), 'Figure12b');
