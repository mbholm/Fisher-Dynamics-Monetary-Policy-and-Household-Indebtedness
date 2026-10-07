%% fig10_by_initial_dti.m
%
% Figure 10: Monetary policy responses by initial debt-to-income
%
% Groups: 1 = bottom 60 percent, 2 = 60-80 percent, 3 = top 20 percent of the
% debt-to-income distribution at the beginning of the year.
%
% Input:  data/server_output/v3A_micro_DTI622groups_*_r0_b1_c1_romer_iv.csv
%         (1_server_stata/fig10_by_initial_dti.do)
% Output: results/figures/Figure10a.eps/.png  debt-to-income
%         results/figures/Figure10b.eps/.png  nominal debt change
%         results/figures/Figure10c.eps/.png  Fisher dynamics

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


suffix = '_r0_b1_c1_romer_iv';
styles = {'--', '-s', '-'};      % black lines told apart by line style and marker
labels = {'Bottom 60%', '60-80%', 'Top 20%'};

% the legend is shown in panel (a) only
plot_irf_groups(read_lp(['v3A_micro_DTI622groups_diff_deb_inc' suffix]),         1:3, styles, labels, 'Figure10a', 'YLim', [-8 2], 'LegendFont', 14);
plot_irf_groups(read_lp(['v3A_micro_DTI622groups_dti_debt_nom' suffix]),         1:3, styles, labels, 'Figure10b', 'YLim', [-8 2], 'LegendFont', 14, 'Legend', false);
plot_irf_groups(read_lp(['v3A_micro_DTI622groups_dti_income_total_nom' suffix]), 1:3, styles, labels, 'Figure10c', 'YLim', [-8 2], 'LegendFont', 14, 'Legend', false);
