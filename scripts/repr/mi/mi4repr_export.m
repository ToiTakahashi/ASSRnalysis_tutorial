%% Params

n_par = 2;

data_dir = ['datamats' filesep 'datamat_keio'];
data_fs = 500;

f_repr = 1000;
l_repr = 80;
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

%subject_idx = 1;
for subject_idx = 1:n_data
subject = subjects{subject_idx};

n_column = size(subject.data_repr, 2);
disp(['c-' num2str(n_column)])

%column_idx = 1;
for column_idx = 1:n_column

%% Analyze MI
repr = compute_mi(subject.data_repr(:,column_idx), subject.fs, compute_opts);
sil = compute_mi(subject.data_sil(:,column_idx), subject.fs, compute_opts);

%% Export flip seq(for saving)

export_id = ['s-' num2str(subject_idx) 'c-' num2str(column_idx)];

rseq = export_mi(repr);
sseq = export_mi(sil);
mat_filename = ['seq_' export_id '.mat'];
save(mat_filename, 'rseq', 'sseq')

end % column
end % subject

%% Extra: Export seq(for plotting)

rmi = [repr.dp_mi{:}]';
smi = [sil.dp_mi{:}]';

[rmi_max, rmi_max_idx] = max(rmi);
[smi_max, smi_max_idx] = max(smi);

rseq = repr.dp_seq{rmi_max_idx};
sseq = sil.dp_seq{smi_max_idx};

rseq_len = length(rseq);
sseq_len = length(sseq);

rseq_o = mean(rseq(1:2:rseq_len));
rseq_e = mean(rseq(2:2:rseq_len));
if rseq_o >= rseq_e
    assert((rseq_o>0)&(rseq_e<0))
    rseq = rseq(1:(end-1));
else
    assert((rseq_o<0)&(rseq_e>0))
    rseq = rseq(2:end);
end

sseq_o = mean(sseq(1:2:sseq_len));
sseq_e = mean(sseq(2:2:sseq_len));
if sseq_o >= sseq_e
    assert((sseq_o>0)&(sseq_e<0))
    sseq = sseq(1:(end-1));
else
    assert((sseq_o<0)&(sseq_e>0))
    sseq = sseq(2:end);
end

%% Extra: Plot MI

f1 = figure();
subplot(2,1,1)
boxplot([rmi, smi], 'Notch', 'on', 'Labels', {'repr','sil'})
title('Distribution of MI value')
subplot(2,1,2)
hold on
plot(zeros(clip_shift_pattern, 1), rmi, 'o')
plot(ones(clip_shift_pattern, 1), smi, 'o')
hold off
xlim([-0.5, 1.5])
title('Distribution of MI value(raw)')

f2 = figure();
ax(1)=subplot(2,1,1);
plot(rseq)
title('Sequence giving Max MI for repr(corrected)')
ax(2)=subplot(2,1,2);
plot(sseq)
title('Sequence giving Max MI for sil(corrected)')
linkaxes(ax)
ylim([-1.1, 1.1])
xlim([1, 10])
