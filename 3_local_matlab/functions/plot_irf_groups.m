function plot_irf_groups(est, groups, styles, labels, figname, varargin)
% PLOT_IRF_GROUPS  Impulse responses (point estimates) of several household groups.
%
%   plot_irf_groups(est, groups, styles, labels, figname) plots, for each
%   group number in the vector groups, the point estimates for horizons
%   0,...,5 from the stacked estimates in est (see read_lp), and saves the
%   figure as results/figures/<figname>.eps and <figname>.png.
%
%   The figures are drawn in black and gray, and the groups are told apart by
%   line style and marker, so that the figures can be read in black and white.
%
%       styles   cell array of line specifications (line style and marker),
%                one per group, e.g. '--o'
%       labels   cell array of legend entries, one per group
%
%   Optional name-value pairs:
%       'Colors'      cell array of RGB colors, one per group (default: black)
%       'YLim'        [lower upper]  limits of the vertical axis (default: tight)
%       'Legend'      true/false     show the legend (default: true)
%       'Location'    text           legend location (default: 'Northwest')
%       'NumColumns'  number         columns in the legend (default: 5)
%       'LegendFont'  number         legend font size; [] keeps the axes font size

opt = inputParser;
addParameter(opt, 'Colors', {});
addParameter(opt, 'YLim', []);
addParameter(opt, 'Legend', true);
addParameter(opt, 'Location', 'Northwest');
addParameter(opt, 'NumColumns', 5);
addParameter(opt, 'LegendFont', []);
parse(opt, varargin{:});

IRF_T = 6;   % number of horizons (h = 0,...,5)

zero_line = zeros(IRF_T, 1);

figure()
hold on;
hl = gobjects(numel(groups), 1);
for jj = 1:numel(groups)
    g      = groups(jj);
    rows   = IRF_T*(g-1)+1 : IRF_T*g;
    hl(jj) = plot(est(rows,1), styles{jj}, 'Linewidth', 2, 'Color', 'k', 'MarkerSize', 7, 'MarkerFaceColor', 'w');
    if ~isempty(opt.Results.Colors)
        set(hl(jj), 'Color', opt.Results.Colors{jj});
    end
end
plot(zero_line,'black')
hold off;
axis tight
xlim([1 IRF_T])
xticks(1:IRF_T)
xticklabels({'0','1','2','3','4','5'})
if ~isempty(opt.Results.YLim)
    ylim(opt.Results.YLim)
end
ylabel('Percentage Points','fontsize',14)
xlabel('Years','fontsize',14)
grid on
set(gca,'GridLineStyle','--')
set(gca,'fontsize',14)
ax = gca;
ax.GridAlpha = .5;
if isempty(opt.Results.LegendFont)
    hleg = legend(hl, labels,'Location',opt.Results.Location,'NumColumns',opt.Results.NumColumns,'Box','Off');
else
    hleg = legend(hl, labels,'Location',opt.Results.Location,'NumColumns',opt.Results.NumColumns,'Fontsize',opt.Results.LegendFont,'Box','Off');
end
if ~opt.Results.Legend
    set(hleg,'visible','off')
end

h = gcf;
set(h,'PaperPositionMode','auto')
set(h,'PaperOrientation','landscape')
set(h,'Units','inches','Position',[0 0 6.25 4.1667])   % fixed physical size, independent of the screen
tightfig;

p = replication_paths();
print(h,'-depsc',fullfile(p.figures, figname))
print(h,'-dpng','-r300',fullfile(p.figures, figname))

end
