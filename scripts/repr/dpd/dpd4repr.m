%% Params

n_par = 2;
use_matmul = true;

data_dir = ['datamats' filesep 'datamat_rion_500Hz'];
data_fs = 500;

f_repr = 4000;
l_repr = 30;
analysis_freq = 40;
analysis_dur = 30;

repr_txt = ['CF' num2str(f_repr) 'Hz-MF' num2str(analysis_freq) 'Hz-dB' num2str(l_repr) '-'...
            num2str(analysis_dur) 's-fs' num2str(data_fs) 'Hz'];
sil_txt = ['CF-1Hz-MF-1Hz-dB-1-' num2str(analysis_dur) 's-fs' num2str(data_fs) 'Hz'];

[p, q] = rat(data_fs/analysis_freq, 1e-12); % p/q [sample/cycle]
clip_len_corr = (p/q)/2; % sample, 1/2 cycle, double
clip_shift_step = ceil(data_fs*2/1000); % ~2ms
clip_shift_pattern = ceil((p/q)/clip_shift_step); % cover 1 cycle

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
eval_opt = 'RMS'; % main

compute_opts = struct();
compute_opts.n_par = n_par;
compute_opts.clip_len = clip_len_corr;
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

%% Analyze DPD
repr = compute_dpd(subject.data_repr(:,column_idx), subject.fs, compute_opts);
sil = compute_dpd(subject.data_sil(:,column_idx), subject.fs, compute_opts);

%% Plot DPD

ax = gobjects(2,1);
figure()
ax(1) = subplot(2,1,1); hold on
idx = repr.dp_div_best_idx;
plot(repr.dp_center{idx}, repr.dp_hist_ii{idx}, 'r', 'DisplayName', 'ii')
plot(repr.dp_center{idx}, repr.dp_hist_dd{idx}, 'g', 'DisplayName', 'dd')
plot(repr.dp_center{idx}, repr.dp_hist_id{idx}, 'b', 'DisplayName', 'id')
legend('Location', 'North')
repr_dp_txt = ['(DPD:' num2str(repr.dp_div_best) ')'];
title([repr_txt repr_dp_txt])
ax(2) = subplot(2,1,2); hold on
idx = sil.dp_div_best_idx;
plot(sil.dp_center{idx}, sil.dp_hist_ii{idx}, 'r', 'DisplayName', 'ii')
plot(sil.dp_center{idx}, sil.dp_hist_dd{idx}, 'g', 'DisplayName', 'dd')
plot(sil.dp_center{idx}, sil.dp_hist_id{idx}, 'b', 'DisplayName', 'id')
legend('Location', 'North')
sil_dp_txt = ['(DPD:' num2str(sil.dp_div_best) ')'];
title([sil_txt sil_dp_txt])
linkaxes(ax)
xlim([-7, 7])
tunefig('document', gcf)
fig_title = ['DPD-' repr_txt '.fig'];

%%
savefig(fig_title)
