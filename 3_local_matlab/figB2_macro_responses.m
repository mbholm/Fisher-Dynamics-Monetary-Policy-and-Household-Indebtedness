%% figB2_macro_responses.m
%
% Figure B2 (Online Appendix): Macro responses to monetary policy shocks
%
% Annual local projections of the policy rate, real GDP, and the consumer price
% index on the narrative monetary policy shocks of Holm, Paul, and Tischbirek
% (2021), 1994-2018, with three lags of the shock as controls (no controls for
% the policy rate) and Newey-West standard errors (function hac from the
% Econometrics Toolbox, Bartlett kernel).
%
% Input:  data/monetary_policy_shocks/narrative_shocks_meeting.csv
%         data/macro/macro_annual.csv
% Output: results/figures/FigureB2a.eps  interest rate
%         results/figures/FigureB2b.eps  GDP
%         results/figures/FigureB2c.eps  consumer price index

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));

p = replication_paths();

%% Settings

start_year          = 1994;     % estimation sample
end_year            = 2018;
lags_annual_shock   = 3;        % lags of the shock included as controls
IRF_T_annual        = 6;        % horizons 0,...,5

%% Load data

% macro data, annual: year, policy rate, real GDP, CPI-AEL, investment, wages, unemployment
macro               = readmatrix(fullfile(p.macro, 'macro_annual.csv'));
date_MA_annual      = macro(:,1);
macro_data_annual   = macro(:,2:end);

% monetary policy shocks by meeting: month, day, year, shock
shocks              = readmatrix(fullfile(p.shocks, 'narrative_shocks_meeting.csv'));
date_MP             = shocks(:,1:3);
MP_shocks           = shocks(:,4);

labels_annual2      = {'a','b','c'};    % panels: policy rate, GDP, consumer price index
y_labels_annual     = [1 0 0];          % 1: percentage points, 0: percent
ind_PR_annual       = 1;

%% Annual shock series: sum of the meeting-level shocks within the year

MP_shocks_annual    = zeros(size(date_MA_annual,1),1);
for jj = 1:size(MP_shocks_annual,1)
    for kk = 1:size(MP_shocks,1)
        if date_MP(kk,3) == date_MA_annual(jj,1)
            if isnan(MP_shocks(kk,1))==0
                MP_shocks_annual(jj,1) = MP_shocks_annual(jj,1) + MP_shocks(kk,1);
            end
        end
    end
end

%% Dependent variables: change between t-1 and t+h (policy rate) or 100 x log change

Y_change_annual = NaN(size(MP_shocks_annual,1),IRF_T_annual,3);
for mm = 1:3
    for jj = 2:size(Y_change_annual,1)
        for kk = 1:IRF_T_annual
            if jj<=size(Y_change_annual,1)-kk+1
                if mm == ind_PR_annual
                    Y_change_annual(jj,kk,mm) = macro_data_annual(jj+kk-1,mm)-macro_data_annual(jj-1,mm);
                else
                    Y_change_annual(jj,kk,mm) = 100*(log(macro_data_annual(jj+kk-1,mm))-log(macro_data_annual(jj-1,mm)));
                end
            end
        end
    end
end

%% Local projections

beta_annual         = zeros(IRF_T_annual,5*3);
start_macro         = start_year - date_MA_annual(1) + 1;
end_macro           = end_year   - date_MA_annual(1) + 1;

% lags of the shock
controls_annual_shock = NaN(size(date_MA_annual,1),lags_annual_shock);
for jj = 1:lags_annual_shock
    controls_annual_shock(:,jj)      = [NaN(jj,1);MP_shocks_annual(1:end-jj,1)];
end

for mm = 1:3

    XX = [MP_shocks_annual controls_annual_shock];

    % no controls for the policy rate
    if mm == ind_PR_annual
        XX = MP_shocks_annual(:,1);
    end

    XX = XX(start_macro:end_macro,:);

    for jj = 1:IRF_T_annual

        YY = Y_change_annual(start_macro:end_macro,jj,mm);

        maxLag              = floor(4*(size(XX,1)/100)^(2/9));
        [~, se, coeff]      = hac(XX, YY, 'bandwidth', maxLag+1, 'display', 'off');   % Newey-West (Bartlett kernel), Econometrics Toolbox
        est_beta            = coeff(2,1);
        est_se              = se(2,1);
        df                  = size(YY,1)-sum(isnan(YY))-size(XX,2)-1;

        beta_annual(jj,1+(mm-1)*5)   = est_beta;
        beta_annual(jj,2+(mm-1)*5)   = est_beta-tinv(0.975,df)*est_se;
        beta_annual(jj,3+(mm-1)*5)   = est_beta-tinv(0.84,df)*est_se;
        beta_annual(jj,4+(mm-1)*5)   = est_beta+tinv(0.84,df)*est_se;
        beta_annual(jj,5+(mm-1)*5)   = est_beta+tinv(0.975,df)*est_se;

    end
end

%% Figures

zero_line = zeros(size(beta_annual,1),1);

for mm = 1:3
    figure()
    hold on;
    plot(beta_annual(:,1+(mm-1)*5),'b','Linewidth',3,'Color',rgb('Mediumblue'))
    plot(beta_annual(:,2+(mm-1)*5),'b','Linewidth',1,'Color',rgb('Mediumblue'))
    plot(beta_annual(:,3+(mm-1)*5),'b','Linewidth',1,'Color',rgb('Mediumblue'))
    plot(beta_annual(:,4+(mm-1)*5),'b','Linewidth',1,'Color',rgb('Mediumblue'))
    plot(beta_annual(:,5+(mm-1)*5),'b','Linewidth',1,'Color',rgb('Mediumblue'))
    ciplot_adj(beta_annual(:,3+(mm-1)*5),beta_annual(:,4+(mm-1)*5));
    ciplot_adj(beta_annual(:,2+(mm-1)*5),beta_annual(:,5+(mm-1)*5));
    plot(zero_line,'black')
    hold off;
    axis tight
    set(gca,'Box','on','FontSize',14)
    xlim([1 size(beta_annual,1)])
    xticks(1:1:size(beta_annual,1))
    xticklabels({'0','1','2','3','4','5'})
    if y_labels_annual(1,mm) == 1
        ylabel('Percentage Points','fontsize',14)
    else
        ylabel('Percent','fontsize',14)
    end
    xlabel('Year','fontsize',14)
    set(gca,'fontsize',14)
    h = gcf;
    set(h, 'PaperPositionMode','auto')
    set(h,'PaperOrientation','landscape')
    set(h,'Units','inches','Position',[0 0 4.1667 2.7778])   % fixed physical size (as in the published figures), independent of the screen
    tightfig;
    print(h,'-depsc',fullfile(p.figures, ['FigureB2' labels_annual2{mm}]))
end
