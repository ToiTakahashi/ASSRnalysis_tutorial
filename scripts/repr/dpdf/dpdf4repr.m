%% Params

n_par = 2;
use_matmul = true;

data_dir = ['datamats' filesep 'datamat_rion_500Hz'];
data_fs = 500;

f_repr = 4000;
l_repr = 30;
analysis_freq = 40;
analysis_dur = 59;

repr_txt = ['CF' num2str(f_repr) 'Hz-MF' num2str(analysis_freq) 'Hz-dB' num2str(l_repr) '-'...
            num2str(analysis_dur) 's-fs' num2str(data_fs) 'Hz'];
sil_txt = ['CF-1Hz-MF-1Hz-dB-1-' num2str(analysis_dur) 's-fs' num2str(data_fs) 'Hz'];

[p, q] = rat(data_fs/analysis_freq, 1e-12); % p/q [sample/cycle]
clip_len_corr_full = p/q; % sample, 1 cycle, double
clip_shift_step = 0;
clip_shift_pattern = 1;

preproc_opts = cell(2,1);
preproc_opts{1} = struct();
preproc_opts{1}.mode = 'filt';
preproc_opts{1}.mf = analysis_freq;
preproc_opts{1}.order = round(data_fs*1000/1000); % 1000ms
preproc_opts{1}.cutoff = 0.5;
preproc_opts{2} = struct();
preproc_opts{2}.mode = 'demean_normalize';

% choose a measure of similarity
dp_opt = 'dot product';
hist_div = 2001;
hist_scaler = 2000;
hist_opt = 'probabilityScaled'; % main
eval_opt = 'CR'; % main

compute_opts = struct();
compute_opts.n_par = n_par;
compute_opts.clip_len = clip_len_corr_full;
compute_opts.clip_shift_step = clip_shift_step;
compute_opts.clip_shift_pattern = clip_shift_pattern;
compute_opts.preproc_opts = preproc_opts;
compute_opts.dp_opt = dp_opt;
compute_opts.hist_div = hist_div;
compute_opts.hist_scaler = hist_scaler;
compute_opts.hist_opt = hist_opt;
compute_opts.eval_opt = eval_opt;
compute_opts.use_matmul = use_matmul;

%% Load Data
subjects = load_repr(data_dir, f_repr, l_repr);
subjects = split_subjects(subjects, analysis_dur);
n_data = length(subjects);
disp(['s-' num2str(n_data)])

subject_idx = 1;
subject = subjects{subject_idx};

n_column = size(subject.data_repr, 2);
disp(['c-' num2str(n_column)])

column_idx = 1;

%% Analyze DPDf
repr = compute_dpdf(subject.data_repr(:,column_idx), subject.fs, compute_opts);
sil = compute_dpdf(subject.data_sil(:,column_idx), subject.fs, compute_opts);

%% Plot DPDf

ax = gobjects(2,1);
figure()
ax(1) = subplot(2,1,1); hold on
idx = repr.dp_div_best_idx;
plot(repr.dp_center{idx}, repr.dp_hist{idx}, 'r')
grid on; grid minor;
repr_dpf_txt = ['(DPDf:' num2str(repr.dp_div_best) ')'];
title([repr_txt repr_dpf_txt])
ax(2) = subplot(2,1,2); hold on
idx = sil.dp_div_best_idx;
plot(sil.dp_center{idx}, sil.dp_hist{idx}, 'k')
grid on; grid minor;
sil_dpf_txt = ['(DPDf:' num2str(sil.dp_div_best) ')'];
title([sil_txt sil_dpf_txt])
linkaxes(ax)
xlim([-15, 15])
tunefig('document', gcf)
fig_title = ['DPDf-' repr_txt '.fig'];

%%
savefig(fig_title)
