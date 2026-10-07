function est = read_lp(name)
% READ_LP  Read local-projection estimates exported from the server.
%
%   est = read_lp(name) reads data/server_output/<name>.csv. The file has one
%   row per horizon h = 0,...,5 (stacked by household group for group-level
%   estimates) and three columns:
%       1  point estimate
%       2  standard error (Driscoll-Kraay)
%       3  number of observations
%
% The interest rate change enters the regressions in units of 1/100 of a
% percentage point and the outcomes are ratios, so dividing the estimates and
% standard errors by 100 gives the response in percentage points to a one
% percentage point increase in the interest rate.

p   = replication_paths();
est = readmatrix(fullfile(p.server, [name '.csv']));

if size(est, 2) ~= 3 || mod(size(est, 1), 6) ~= 0
    error('read_lp:format', 'Unexpected format in %s.csv', name);
end

est(:, 1:2) = est(:, 1:2) ./ 100;

end
