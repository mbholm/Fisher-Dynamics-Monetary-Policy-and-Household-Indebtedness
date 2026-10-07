%% fig07_shock_series.m
%
% Figure 7: Monetary policy shock series
%
% Annual narrative shocks from Holm, Paul, and Tischbirek (2021) and annual
% market-based shocks from Brubakk et al. (2022), in basis points, for the
% period where both series exist.
%
% Input:  data/monetary_policy_shocks/narrative_shocks_annual.csv
%         data/monetary_policy_shocks/market_shocks_annual.csv
%         (market_shocks/construct_market_based_shocks.m)
% Output: results/figures/Figure07.eps
%
% Note: the script that drew the published figure was not kept. This file
% re-creates the figure from the same two series.

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


p = replication_paths();

narrative = readmatrix(fullfile(p.shocks, 'narrative_shocks_annual.csv'));   % year, shock in percentage points
market    = readmatrix(fullfile(p.shocks, 'market_shocks_annual.csv'));      % year, shock in percentage points

years = (2001:2018)';
[~, in] = ismember(years, narrative(:,1));
[~, im] = ismember(years, market(:,1));

figure()
hold on
plot(years, 100*narrative(in,2), 'k-',  'LineWidth', 2)
plot(years, 100*market(im,2),    'k--', 'LineWidth', 2)
hold off
xlim([2000 2018])
ylim([-300 250])
xticks(2000:2:2018)
yticks(-300:50:250)
grid on
box on
xtickangle(0)
xlabel('Year', 'FontSize', 16)
ylabel('Basis Points', 'FontSize', 16)
legend({'Holm, Paul, and Tischbirek (2021)', 'Brubakk, Ter Ellen, Robstad, and Xu (2022)'}, ...
    'Location', 'Northwest', 'FontSize', 13, 'Box', 'Off')

set(gcf,'Units','inches','Position',[0 0 5.8333 4.375])   % Matlab's default figure size, independent of the screen
set(gcf,'PaperPositionMode','auto')
print(gcf, '-depsc', fullfile(p.figures, 'Figure07'))
