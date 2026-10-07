function p = replication_paths()
% REPLICATION_PATHS  Folders of the replication package.
%
%   p.root      root folder of the replication package
%   p.server    estimates exported from Statistics Norway's server (csv)
%   p.shocks    monetary policy shock series
%   p.macro     macroeconomic data
%   p.cpi       consumer price indices by household group
%   p.figures   folder the figures are written to
%
% The paths are derived from the location of this file, so the Matlab files
% can be run from any working directory.

here      = fileparts(mfilename('fullpath'));          % .../3_local_matlab/functions
p.root    = fileparts(fileparts(here));
p.server  = fullfile(p.root, 'data', 'server_output');
p.shocks  = fullfile(p.root, 'data', 'monetary_policy_shocks');
p.macro   = fullfile(p.root, 'data', 'macro');
p.cpi     = fullfile(p.root, 'data', 'cpi');
p.figures = fullfile(p.root, 'results', 'figures');

if ~exist(p.figures, 'dir')
    mkdir(p.figures);
end

end
