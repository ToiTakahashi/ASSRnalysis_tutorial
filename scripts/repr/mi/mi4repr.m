%% Params

n_par = 2;

data_dir = ['datamats' filesep 'datamat_rion_500Hz'];
data_fs = 500;

f_repr = 500;
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

compute_opts = struct();
compute_opts.n_par = n_par;
compute_opts.clip_len = clip_len_corr;
compute_opts.clip_shift_step = clip_shift_step;
compute_opts.clip_shift_pattern = clip_shift_pattern;
compute_opts.preproc_opts = preproc_opts;

%% Load data
subjects = load_repr(data_dir, f_repr, l_repr);
subjects = split_subjects(subjects, analysis_dur);
n_data = length(subjects);
disp(['s-' num2str(n_data)])

subject_idx = 1;
subject = subjects{subject_idx};

n_column = size(subject.data_repr, 2);
disp(['c-' num2str(n_column)])

column_idx = 1;

%% Analyze MI
repr = compute_mi(subject.data_repr(:,column_idx), subject.fs, compute_opts);
sil = compute_mi(subject.data_sil(:,column_idx), subject.fs, compute_opts);

%% Plot MI

ax = gobjects(2,1);
figure()
ax(1)=subplot(2,1,1);
idx = repr.dp_mi_best_idx;
plot(repr.dp_seq{idx}, 'r.-')
repr_mi_txt = ['(MI:' num2str(repr.dp_mi_best) ')'];
title([repr_txt repr_mi_txt])
ax(2)=subplot(2,1,2);
idx = sil.dp_mi_best_idx;
plot(sil.dp_seq{idx}, 'k.-')
sil_mi_txt = ['(MI:' num2str(sil.dp_mi_best) ')'];
title([sil_txt sil_mi_txt])
linkaxes(ax)
ylim([-1.2, 1.2])
tunefig('document', gcf)
fig_title = ['MI-' repr_txt '.fig'];

%%
savefig(fig_title)
