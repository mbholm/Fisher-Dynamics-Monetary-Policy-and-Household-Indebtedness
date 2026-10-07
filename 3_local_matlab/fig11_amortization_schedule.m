%% fig11_amortization_schedule.m
%
% Figure 11: Share of households whose debt deviates from a hypothetical amortization schedule
%
% Input:  data/server_output/mortgage_deviation.csv  (columns: time since house
%         purchase, share of households deviating from the schedule)
%         (1_server_stata/fig11_amortization_schedule.do)
% Output: results/figures/Figure11.eps

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));


p = replication_paths();

data_md = readmatrix(fullfile(p.server, 'mortgage_deviation.csv'));

figure()
plot(data_md(:,1),(1-data_md(:,2))*100,'k-','Linewidth',2);
xlabel('Time Since House Purchase')
ylabel('Share on Original Amortization Schedule in %')
xlim([0 10])
grid on
h = gcf;
set(h,'Units','inches','Position',[0 0 5.8333 4.375])   % Matlab's default figure size, independent of the screen
set(h,'PaperPositionMode','auto')
print(h,'-depsc',fullfile(p.figures, 'Figure11'))
