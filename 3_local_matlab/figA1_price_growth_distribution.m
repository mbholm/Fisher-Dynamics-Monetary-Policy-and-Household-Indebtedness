%% figA1_price_growth_distribution.m
%
% Figure A1 (Online Appendix): The distribution of price growth across groups
%
% Input:  data/cpi/hhgroup_cpi.csv  (columns: year, household group, price growth in percent)
%         (2_local_stata/figA1_household_price_indices.do)
% Output: results/figures/FigureA1.eps

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


p = replication_paths();

data     = readmatrix(fullfile(p.cpi, 'hhgroup_cpi.csv'));
years    = data(:,1);
p_growth = data(:,3);

figure('Units','inches','Position',[0 0 5.8333 4.375])   % Matlab's default figure size, independent of the screen
boxplot(p_growth,years,'Colors','k','Symbol','','Labels',{'1993','','','1996','','','1999','','','2002','','','2005','','','2008','','','2011','','','2014',''})

xlabel('Year')
ylabel('Price Growth in %')
set(gca,'Fontsize',12)
set(gcf,'PaperPositionMode','auto')
print(fullfile(p.figures, 'FigureA1.eps'), '-depsc')
