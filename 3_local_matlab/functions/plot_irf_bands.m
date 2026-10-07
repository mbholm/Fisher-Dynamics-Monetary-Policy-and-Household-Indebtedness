function plot_irf_bands(est, figname, varargin)
% PLOT_IRF_BANDS  Impulse response with 68 and 95 percent confidence bands.
%
%   plot_irf_bands(est, figname) plots the point estimates est(:,1) for
%   horizons 0,...,5 with confidence bands based on the standard errors
%   est(:,2) and the number of observations est(:,3), and saves the figure as
%   results/figures/<figname>.eps.
%
%   Optional name-value pairs:
%       'YLim'      [lower upper]   limits of the vertical axis (default: tight)
%       'YLabel'    text            (default: 'Percentage Points')
%       'XLabel'    text            (default: 'Years')

opt = inputParser;
addParameter(opt, 'YLim', []);
addParameter(opt, 'YLabel', 'Percentage Points');
addParameter(opt, 'XLabel', 'Years');
parse(opt, varargin{:});

IRF_T       = 6;       % number of horizons (h = 0,...,5)
sign_outer  = 0.05;    % significance level of the outer confidence band
sign_inner  = 0.32;    % significance level of the inner confidence band
k_lp        = 6;       % number of regressors in the local projections (excl. constant)

if size(est, 1) ~= IRF_T
    error('plot_irf_bands:size', 'est must have %d rows', IRF_T);
end

b  = est(:, 1);
se = est(:, 2);
df = est(:, 3) - k_lp - 1;

ci_lower_in     = b - tinv(1-sign_inner/2, df).*se;
ci_upper_in     = b + tinv(1-sign_inner/2, df).*se;
ci_lower_out    = b - tinv(1-sign_outer/2, df).*se;
ci_upper_out    = b + tinv(1-sign_outer/2, df).*se;

zero_line = zeros(IRF_T, 1);

figure()
hold on
plot(b,'b','Linewidth',3,'Color',rgb('Mediumblue'))
plot(ci_lower_out,'b','Linewidth',1,'Color',rgb('Mediumblue'))
plot(ci_lower_in,'b','Linewidth',1,'Color',rgb('Mediumblue'))
plot(ci_upper_in,'b','Linewidth',1,'Color',rgb('Mediumblue'))
plot(ci_upper_out,'b','Linewidth',1,'Color',rgb('Mediumblue'))
ciplot_adj(ci_lower_in,ci_upper_in);
ciplot_adj(ci_lower_out,ci_upper_out);
plot(zero_line,'black')
hold off;
axis tight
xlim([1 IRF_T])
if ~isempty(opt.Results.YLim)
    ylim(opt.Results.YLim)
end
xticks(1:IRF_T)
xticklabels({'0','1','2','3','4','5'})
ylabel(opt.Results.YLabel,'fontsize',14)
xlabel(opt.Results.XLabel,'fontsize',14)
set(gca,'fontsize',14)
h = gcf;
set(h,'PaperPositionMode','auto')
set(h,'PaperOrientation','landscape')
set(h,'Units','inches','Position',[0 0 4.1667 2.7778])   % fixed physical size (as in the published figures), independent of the screen
tightfig;

p = replication_paths();
print(h,'-depsc',fullfile(p.figures, figname))

end
