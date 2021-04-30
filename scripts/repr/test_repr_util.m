%close all
%clear
%clc

setup_fig();

%%

% use YAML to specify params?
fig_dir = 'figs_09MT2_fs500\test'; %'figs_20210330';
if ~isfolder(fig_dir)
    mkdir(fig_dir)
end

%%

% analysis_fs (EEG sampling frequency)
data_fs = 500;
%data_fs = 1000;
%data_fs = 20000;

% load all files in this directory
data_dir = ['C:\Users\toiap\Documents\workspace\experiments\EEG\ASSR\share\datamats\datamats_RION\09MT2\fs500\mf40'];

% Set conditions (career frequency & loudness) to analize.
% Number of elements in "f_reprs" and "l_reprs" must be the same.
f_reprs = repmat(500,1,4); % repmat(4000,1,4); % list of career frequency [Hz]
l_reprs = [30, 20, 10, 0]; % list of loudness [dBSPL]

assert(length(f_reprs)==length(l_reprs))
n_reprs = length(f_reprs);
f_repr = f_reprs(1);
l_repr = l_reprs(1);

% During analysis, EEG data will be split into short time durations.
% ex) 30000x1 double -> 10000x1 double, 10000x1 double, 10000x1 double
% So, set analysis durations here.
analysis_durs = [30]; %[299, 99, 30, 10]; % EEG data length[s] for analysis

n_dur = length(analysis_durs);
analysis_dur = analysis_durs(1);

%%

analysis_freq = 40; % 80; % modulation frequency [Hz}

%%%%%%%%%%%%%% settings to edit is over %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% DIV/MI/CSM
[p, q] = rat(data_fs/analysis_freq, 1e-12); % p/q [sample/cycle]
clip_len = p; % sample, >=1 cycle, int
clip_len_corr = (p/q)/2; % sample, 1/2 cycle, double
clip_len_corr_full = p/q; % sample, 1 cycle, double
% fs/clip_len_csm[Hz] resolution starting from 0[Hz]
%csm_n_cycle = ceil(analysis_freq); % 1[Hz] resolution
%csm_n_cycle = ceil(analysis_freq/2); % 2[Hz] resolution
csm_n_cycle = 40;
if q >= csm_n_cycle
    clip_len_csm = p;% sample, >=`csm_n_cycle` cycle, int
else
    clip_len_csm = p*ceil(csm_n_cycle/q);
end

% DIV/MI
n_par = 2;

% case 1: based on dt
clip_shift_step = ceil(data_fs*2/1000); % ~2ms
clip_shift_pattern = ceil((p/q)/clip_shift_step); % cover 1 cycle

% case 2: based on 1 cycle
%clip_shift_pattern = 13;
%clip_shift_step = ceil((p/q)/clip_shift_pattern);

% TODO: automatically select this option for DPDf only
% case 3: single shot(DPDf)
%clip_shift_step = 0; % arbitrary
%clip_shift_pattern = 1;

% DIV/MI
preproc_opts = cell(2,1);
preproc_opts{1} = struct();
preproc_opts{1}.mode = 'filt';
preproc_opts{1}.mf = analysis_freq;
preproc_opts{1}.order = round(data_fs*1000/1000); % 1000ms
preproc_opts{1}.cutoff = 0.5;
preproc_opts{2} = struct();
preproc_opts{2}.mode = 'demean_normalize';

% DIV
% choose a measure of similarity
dp_opt = 'dot product';

hist_div = 2001;
hist_scaler = 2000;

%hist_opt = 'raw';
%hist_opt = 'probablity';
hist_opt = 'probabilityScaled'; % main
%hist_opt = 'pdf';

% TODO: automatic selection
eval_opt = 'RMS'; % main(DPD)
%eval_opt = 'fKL';
%eval_opt = 'rKL';
%eval_opt = 'JS';
%eval_opt = 'CR'; % main(DPDf)

%use_matmul = true;
use_matmul = false;

% CSM
n_segment = 10;

% DIV/MI/CSM
compute_opts = struct();
compute_opts.clip_len = clip_len; % default

% DIV/MI
compute_opts.n_par = n_par;
compute_opts.clip_shift_step = clip_shift_step;
compute_opts.clip_shift_pattern = clip_shift_pattern;
compute_opts.preproc_opts = preproc_opts;

% DIV
compute_opts.dp_opt = dp_opt;
compute_opts.hist_div = hist_div;
compute_opts.hist_scaler = hist_scaler;
compute_opts.hist_opt = hist_opt;
compute_opts.eval_opt = eval_opt;
compute_opts.use_matmul = use_matmul;

% CSM
compute_opts.n_segment = n_segment;

%%

% unnecessary param?
% links with `eval_opt`
test_opt = struct();
test_opt.type = 'threshold'; % fast
%test_opt.type = 'fKL'; % forward
%test_opt.type = 'rKL'; % reverse
%test_opt.type = 'JS'; % symmetric

n_thresh = 1000;

%%
disp('params set')
