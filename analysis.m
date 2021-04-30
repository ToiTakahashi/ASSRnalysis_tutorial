% program called by run_analysis.sh

% Move to script directory and add path
tmp_c = mfilename('fullpath');
[tmp_p,~,~] = fileparts(tmp_c);
cd(tmp_p);
addpath(genpath('.'))

% Run analysis
%  Configure `test_repr_util.m`
test_repr_multi;
test_repr_LOSOCV_multi;
