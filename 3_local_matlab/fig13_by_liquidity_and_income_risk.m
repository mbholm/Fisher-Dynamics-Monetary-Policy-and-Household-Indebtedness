%% fig13_by_liquidity_and_income_risk.m
%
% Figure 13: The debt-to-income response to monetary policy by liquidity, predicted unemployment risk and sector of employment
%
% Input:  data/server_output/v3A_micro_<group>groups_diff_deb_inc_r0_b1_c1_romer_iv.csv
%         for <group> = LIQ, LIQSUB, DTIUNEMP3, sector
%         (1_server_stata/fig13_by_liquidity_and_income_risk.do)
% Output: results/figures/Figure13a.eps/.png  liquid assets (quintiles of deposits)
%         results/figures/Figure13b.eps/.png  comprehensive liquidity measure (quintiles)
%         results/figures/Figure13c.eps/.png  predicted unemployment risk, top 20% of debt-to-income
%         results/figures/Figure13d.eps/.png  sector of employment

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


suffix = '_r0_b1_c1_romer_iv';
q_styles = {'--o', ':^', '-.d', '-s', '-'};   % black lines told apart by line style and marker
q_labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};

% (a) liquid assets
plot_irf_groups(read_lp(['v3A_micro_LIQgroups_diff_deb_inc' suffix]), 1:5, q_styles, q_labels, 'Figure13a');

% (b) comprehensive liquidity measure
plot_irf_groups(read_lp(['v3A_micro_LIQSUBgroups_diff_deb_inc' suffix]), 1:5, q_styles, q_labels, 'Figure13b', 'YLim', [-2 1]);

% (c) predicted unemployment risk within the top debt-to-income quintile
%     The server file stacks 10 groups: unemployment-risk group (2) x debt-to-income
%     quintile (5). Group 5 is low unemployment risk and group 10 is high
%     unemployment risk within the top debt-to-income quintile.
plot_irf_groups(read_lp(['v3A_micro_DTIUNEMP3groups_diff_deb_inc' suffix]), [5 10], {'-', '--'}, ...
    {'Low unemp. risk & top 20% DTI', 'High unemp. risk & top 20% DTI'}, 'Figure13c', ...
    'YLim', [-8 3], 'Location', 'Northeast', 'NumColumns', 1, 'LegendFont', 14);

% (d) sector of employment: nine lines, told apart by line style, marker, and black/gray
s_styles = {'-o', '--s', ':^', '-.d', '-v', '--x', ':+', '-.p', '-'};
gray     = [0.55 0.55 0.55];
s_colors = {[0 0 0], gray, [0 0 0], gray, [0 0 0], gray, [0 0 0], gray, [0 0 0]};
plot_irf_groups(read_lp(['v3A_micro_sectorgroups_diff_deb_inc' suffix]), 1:9, s_styles, ...
    {'Manufacturing','Utilities','Construction','Wholesale','Transport','Accomodation','Financial','Public','Other'}, ...
    'Figure13d', 'YLim', [-3 2], 'NumColumns', 3, 'Colors', s_colors);
