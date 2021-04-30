function resample_subject(subject_mat, fs)

subject = load(subject_mat);
am_freq = subject.am_freq;
fs_original = subject.fs;
subject_ID = subject.subject_ID;
transducer_type = subject.transducer_type;
n_cond = subject.n_cond;
dur = subject.dur;
t_cond = cell(1, n_cond);
data_mat = subject.data_mat;
freq_list = subject.freq_list;
loud_list = subject.loud_list;
cond_txt = subject.cond_txt;

for cond = 1:n_cond
    data_original = data_mat{cond};
    data_mat{cond} = myresample(data_original, fs_original, fs);
    t_cond{cond} = (0:1/fs:(length(data_mat{cond})-1)/fs)';
end

[dirpath, filename, ext] = fileparts(subject_mat);
subject_mat_resampled = append('fs', num2str(fs), '-', filename, ext);
save(subject_mat_resampled, 'am_freq', 'cond_txt', 'data_mat', 'dur', 'freq_list', 'fs', 'loud_list', 'n_cond', 'subject_ID', 't_cond', 'transducer_type')

end
