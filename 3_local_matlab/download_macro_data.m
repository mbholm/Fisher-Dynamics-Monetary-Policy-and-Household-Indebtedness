%% download_macro_data.m
%
% Downloads the macroeconomic series in data/macro from their original sources
% through the sources' public interfaces (no user account or key is needed):
%
%   Policy rate (sight deposit rate)     Norges Bank, data.norges-bank.no, series IR/KPRA.SD.R
%   Real GDP                             FRED, series NAEXKP01NOA189S (annual), CLVMNACSCAB1GQNO (quarterly)
%   CPI-AEL                              Statistics Norway, table 05327 (monthly, averaged)
%   Real gross fixed capital formation   Statistics Norway, tables 09189 (annual), 09190 (quarterly, seasonally adjusted)
%   Wages and salaries, mainland Norway  Statistics Norway, table 09175 (quarterly, seasonally adjusted; annual = average)
%   Registered unemployment rate         FRED, series LMUNRRTTNOA156N (annual), LMUNRRTTNOQ156S (quarterly)
%
% Output: data/macro/api_download/macro_annual.csv
%         data/macro/api_download/macro_quarterly.csv
%         (same layout as data/macro/macro_annual.csv and macro_quarterly.csv)
%
% IMPORTANT: The files data/macro/macro_annual.csv and macro_quarterly.csv are
% the data used in the paper (downloaded in 2021) and are NOT overwritten.
% National accounts are revised and rebased over time, so a new download of
% real GDP, investment, and wages differs from those files. The policy rate,
% CPI-AEL, and the unemployment rate are not revised. At the end, this file
% reports how the new download compares with the data used in the paper.
% To draw Figure B2 with the new download, point figB2_macro_responses.m to the
% file in api_download.

clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'functions'));

p      = replication_paths();
outdir = fullfile(p.macro, 'api_download');
if ~exist(outdir, 'dir'), mkdir(outdir); end

warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');

first_year = 1990;      % sample of the files used in the paper
last_year  = 2018;

%% Statistics Norway (PxWebApi: POST a json query to https://data.ssb.no/api/v0/en/table/<table>)

% CPI-AEL (CPI adjusted for tax changes and excluding energy products), monthly index
[t, v]      = ssb_table('05327', {'Konsumgrp', 'JEL_TOTAL'; 'ContentsCode', 'KPIJustIndMnd'});
cpi_year    = cellfun(@(s) str2double(s(1:4)), t);
cpi_month   = cellfun(@(s) str2double(s(6:7)), t);
cpi_quarter = ceil(cpi_month/3);

% real gross fixed capital formation: annual (constant prices) and quarterly (constant prices, seasonally adjusted)
[t, gfcf_a]     = ssb_table('09189', {'Makrost', 'bif.nr83_6'; 'ContentsCode', 'Faste'});
gfcf_a_year     = cellfun(@(s) str2double(s(1:4)), t);
[t, gfcf_q]     = ssb_table('09190', {'Makrost', 'bif.nr83_6'; 'ContentsCode', 'FastePriserSesJust'});
gfcf_q_year     = cellfun(@(s) str2double(s(1:4)), t);
gfcf_q_quarter  = cellfun(@(s) str2double(s(6)), t);

% wages and salaries, mainland Norway, quarterly, seasonally adjusted
[t, wage_q]     = ssb_table('09175', {'NACE', 'nr23_6fn'; 'ContentsCode', 'Lonn2'});
wage_q_year     = cellfun(@(s) str2double(s(1:4)), t);
wage_q_quarter  = cellfun(@(s) str2double(s(6)), t);

%% Norges Bank (SDMX interface: https://data.norges-bank.no/api/data/IR/<key>?format=csv)

rate_a = norges_bank('A.KPRA.SD.R', first_year, last_year);   % annual average
rate_m = norges_bank('M.KPRA.SD.R', first_year, last_year);   % monthly average
rate_a_year    = str2double(string(rate_a.TIME_PERIOD));
tm             = string(rate_m.TIME_PERIOD);
rate_m_year    = str2double(extractBefore(tm, 5));
rate_m_quarter = ceil(str2double(extractAfter(tm, 5))/3);

%% FRED (https://fred.stlouisfed.org/graph/fredgraph.csv?id=<series>)

[gdp_a_date, gdp_a] = fred('NAEXKP01NOA189S');     % real GDP, annual (OECD)
[gdp_q_date, gdp_q] = fred('CLVMNACSCAB1GQNO');    % real GDP, quarterly, seasonally adjusted (Eurostat)
[un_a_date,  un_a]  = fred('LMUNRRTTNOA156N');     % registered unemployment rate, annual (OECD)
[un_q_date,  un_q]  = fred('LMUNRRTTNOQ156S');     % registered unemployment rate, quarterly, seasonally adjusted (OECD)

%% Annual file

years  = (first_year:last_year)';
annual = NaN(numel(years), 7);
annual(:,1) = years;
for ii = 1:numel(years)
    y = years(ii);
    annual(ii,2) = pick(rate_a.OBS_VALUE, rate_a_year == y);
    annual(ii,3) = pick(gdp_a, year(gdp_a_date) == y);
    annual(ii,4) = full_mean(v(cpi_year == y), 12);
    annual(ii,5) = pick(gfcf_a, gfcf_a_year == y);
    annual(ii,6) = full_mean(wage_q(wage_q_year == y), 4);
    annual(ii,7) = pick(un_a, year(un_a_date) == y);
end
names_a = {'year','policy_rate','real_gdp','cpi_ael','real_gross_fixed_capital_formation','wages','registered_unemployment'};
write_csv(fullfile(outdir, 'macro_annual.csv'), names_a, annual);

%% Quarterly file

[qq, yy]  = meshgrid(1:4, years);
yq        = sortrows([yy(:) qq(:)]);
quarterly = NaN(size(yq,1), 8);
quarterly(:,1:2) = yq;
for ii = 1:size(yq,1)
    y = yq(ii,1); q = yq(ii,2);
    quarterly(ii,3) = full_mean(rate_m.OBS_VALUE(rate_m_year == y & rate_m_quarter == q), 3);
    quarterly(ii,4) = pick(gdp_q, year(gdp_q_date) == y & quarter(gdp_q_date) == q);
    quarterly(ii,5) = full_mean(v(cpi_year == y & cpi_quarter == q), 3);
    quarterly(ii,6) = pick(gfcf_q, gfcf_q_year == y & gfcf_q_quarter == q);
    quarterly(ii,7) = pick(wage_q, wage_q_year == y & wage_q_quarter == q);
    quarterly(ii,8) = pick(un_q, year(un_q_date) == y & quarter(un_q_date) == q);
end
names_q = {'year','quarter','policy_rate','real_gdp','cpi_ael','real_gross_fixed_capital_formation','wages_and_salaries_mainland','registered_unemployment'};
write_csv(fullfile(outdir, 'macro_quarterly.csv'), names_q, quarterly);

fprintf('Written: %s\n', fullfile(outdir, 'macro_annual.csv'));
fprintf('Written: %s\n', fullfile(outdir, 'macro_quarterly.csv'));

%% Comparison with the data used in the paper (annual file)

old = readmatrix(fullfile(p.macro, 'macro_annual.csv'));
fprintf('\nComparison with data/macro/macro_annual.csv (data used in the paper)\n');
fprintf('%-38s %14s %20s\n', 'series', 'max |diff|', 'corr. of growth');
for jj = 2:7
    both = ~isnan(old(:,jj)) & ~isnan(annual(:,jj));
    d    = max(abs(old(both,jj) - annual(both,jj)));
    if jj == 2 || jj == 7      % rates: correlation of changes
        c = corrcoef(diff(old(both,jj)), diff(annual(both,jj)));
    else                       % levels: correlation of log changes
        c = corrcoef(diff(log(old(both,jj))), diff(log(annual(both,jj))));
    end
    fprintf('%-38s %14.4g %20.4f\n', names_a{jj}, d, c(1,2));
end
fprintf(['\nReal GDP, investment, and wages are revised and rebased by the statistical agencies,\n' ...
         'so their levels differ from the data used in the paper.\n']);

%% Local functions

function [time, value] = ssb_table(table, selection)
% query a table in Statistics Norway's StatBank; selection is an N x 2 cell array {variable code, value code}
    query = struct('query', {{}}, 'response', struct('format', 'json-stat2'));
    for kk = 1:size(selection, 1)
        query.query{kk} = struct('code', selection{kk,1}, ...
            'selection', struct('filter', 'item', 'values', {selection(kk,2)}));
    end
    opts  = weboptions('MediaType', 'application/json', 'ContentType', 'json', 'Timeout', 180);
    j     = webwrite(['https://data.ssb.no/api/v0/en/table/' table], jsonencode(query), opts);
    time  = fieldnames(j.dimension.Tid.category.index);      % e.g. x1995M01, x1995K1, x1995
    time  = cellfun(@(s) s(2:end), time, 'UniformOutput', false);
    value = j.value;
    if iscell(value)                                         % missing observations are returned as empty cells
        value(cellfun(@isempty, value)) = {NaN};
        value = cell2mat(value);
    end
    value = double(value(:));
    if numel(value) ~= numel(time)
        error('ssb_table:size', 'Table %s: the query must select a single series.', table);
    end
end

function T = norges_bank(key, first_year, last_year)
% policy rate from Norges Bank's open data interface
    url  = sprintf(['https://data.norges-bank.no/api/data/IR/%s?format=csv&startPeriod=%d-01-01' ...
                    '&endPeriod=%d-12-31&bom=include&locale=en'], key, first_year, last_year);
    file = [tempname '.csv'];
    websave(file, url, weboptions('Timeout', 180));
    o = detectImportOptions(file, 'Delimiter', ';');
    o = setvartype(o, 'TIME_PERIOD', 'string');
    T = readtable(file, o);
    delete(file);
end

function [date, value] = fred(series)
% a series from FRED as dates and values
    file = [tempname '.csv'];
    url  = ['https://fred.stlouisfed.org/graph/fredgraph.csv?id=' series];
    % FRED does not always answer Matlab's web client. The download is therefore done
    % with the program curl (part of Windows 10/11, macOS, and Linux), and with
    % Matlab's web client only if curl is not available.
    [status, ~] = system(sprintf('curl -s -f -L -m 120 -o "%s" "%s"', file, url));
    if status ~= 0 || ~exist(file, 'file')
        websave(file, url, weboptions('Timeout', 60));
    end
    T     = readtable(file, 'TextType', 'string');
    delete(file);
    date  = datetime(string(T{:,1}), 'InputFormat', 'yyyy-MM-dd');
    value = T{:,2};
    if ~isnumeric(value), value = str2double(value); end
end

function x = pick(values, index)
% the single observation selected by index, or NaN if there is none
    x = NaN;
    if nnz(index) == 1, x = values(index); end
end

function x = full_mean(values, n)
% the mean of the n observations of a period, or NaN if the period is incomplete
    x = NaN;
    if numel(values) == n && ~any(isnan(values)), x = mean(values); end
end

function write_csv(file, names, data)
% comma-separated text file with a header line; missing values are written as NaN
    fid = fopen(file, 'w');
    fprintf(fid, '%s\n', strjoin(names, ','));
    for ii = 1:size(data, 1)
        fprintf(fid, '%s\n', strjoin(arrayfun(@(x) sprintf('%.15g', x), data(ii,:), 'UniformOutput', false), ','));
    end
    fclose(fid);
end
