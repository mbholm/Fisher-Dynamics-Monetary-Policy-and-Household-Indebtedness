%% construct_market_based_shocks.m
%
% Market-based monetary policy shocks (Section 4.2; Figures 7 and 8).
%
% Extracts two factors from high-frequency interest rate surprises around Norges
% Bank's monetary policy announcements and rotates them so that the first
% factor ("target") is the only one that loads on the surprise in the shortest
% rate. The target factor is scaled to move one-for-one with that surprise and
% summed over the meetings within a calendar year.
%
% NOTE: The high-frequency interest rate surprises are from Brubakk, ter Ellen,
% Robstad, and Xu (2022) and are not included in this package. To run this file,
% obtain them from those authors and place them in the folder below. The
% resulting annual shock series is included in the package.
%
% Input:  data/monetary_policy_shocks/market_based_raw/     (not included)
%             10_20_surprise_mp1_Norges Bank.csv         surprise in the short rate
%             15_75_surprise_NOK3F1=_Norges Bank.csv     surprises in forward rate agreements
%             15_75_surprise_NOK3F2=_Norges Bank.csv
%             15_75_surprise_NOK3F3=_Norges Bank.csv
%             15_75_surprise_NOK3F4=_Norges Bank.csv
%             dates.csv                                  year of each announcement
% Output: data/monetary_policy_shocks/market_based_raw/mpshocksmarket.csv   shock by meeting
%         data/monetary_policy_shocks/market_shocks_annual.csv              annual shock
%
% The annual file is merged onto the household panel on the server
% (when the panel is built; that code is not part of the package).

clear; close all;
here = fileparts(mfilename('fullpath'));
addpath(here);
addpath(fullfile(fileparts(here), 'functions'));

p   = replication_paths();
raw = fullfile(p.shocks, 'market_based_raw');

% surprises in mp1, fra1, fra2, fra3, fra4
MP1  = readmatrix(fullfile(raw, '10_20_surprise_mp1_Norges Bank.csv'),     'Range', [2 2]);
FRA1 = readmatrix(fullfile(raw, '15_75_surprise_NOK3F1=_Norges Bank.csv'), 'Range', [2 2]);
FRA2 = readmatrix(fullfile(raw, '15_75_surprise_NOK3F2=_Norges Bank.csv'), 'Range', [2 2]);
FRA3 = readmatrix(fullfile(raw, '15_75_surprise_NOK3F3=_Norges Bank.csv'), 'Range', [2 2]);
FRA4 = readmatrix(fullfile(raw, '15_75_surprise_NOK3F4=_Norges Bank.csv'), 'Range', [2 2]);

X = [MP1 FRA1 FRA2 FRA3 FRA4];

% standardize
Xnorm = (X - repmat(mean(X),size(X(:,1)))) /diag(std(X));

% extract two factors
[F,lambda] = GSSextract(Xnorm,2);

% rotate the factors so that mp1 loads only on the first factor
alpha1 = 1/sqrt(1+lambda(2,1)^2/lambda(1,1)^2);
alpha2 = sqrt(1-alpha1^2);
U = [alpha1 -alpha2; alpha2 alpha1];

Z = F*U;
Z(:,2) = -Z(:,2);

% scale the first factor so that it moves one-for-one with mp1
regZ1 = regress(X(:,1) , Z(:,1));
Z1r   = Z(:,1)*regZ1;

% shock by meeting
datesMeetings = readtable(fullfile(raw, '10_20_surprise_mp1_Norges Bank.csv'));
datesMeetings = datesMeetings(:,1);
datesMeetings(:,2) = array2table(Z1r);
writetable(datesMeetings, fullfile(raw, 'mpshocksmarket.csv'), 'Delimiter', ',', 'QuoteStrings', 'all')

% annual shock: sum over the meetings within the year
dates    = readmatrix(fullfile(raw, 'dates.csv'));
years    = (2001:2019)';
ShockMat = zeros(length(years),2);
ShockMat(:,1) = years;
for yy = 1:length(years)
    ShockMat(yy,2) = sum(Z1r(dates(:,1) == years(yy)));
end

fid = fopen(fullfile(p.shocks, 'market_shocks_annual.csv'), 'w');
fprintf(fid, 'year,mp_shock_market\n');
fprintf(fid, '%d,%.17g\n', ShockMat');
fclose(fid);
