function trim_subject(subject_mat, dur)

subject = load(subject_mat);
am_freq = subject.am_freq;
fs = subject.fs;
subject_ID = subject.subject_ID;
transducer_type = subject.transducer_type;
n_cond = subject.n_cond;
dur_original = subject.dur;
t_cond = cell(1, n_cond);
data_mat = subject.data_mat;
freq_list = subject.freq_list;
loud_list = subject.loud_list;
cond_txt = subject.cond_txt;

assert(length(dur)==length(dur_original))
assert(all((dur_original-dur)>=0))

for cond = 1:n_cond
    data_original = data_mat{cond};
    data_mat{cond} = data_original(1:dur(cond)*fs);
    t_cond{cond} = (0:1/fs:(length(data_mat{cond})-1)/fs)';
end

subject_mat_trimmed = ['trim-' subject_mat];
save(subject_mat_trimmed, 'am_freq', 'cond_txt', 'data_mat', 'dur', ...
    'freq_list', 'fs', 'loud_list', 'n_cond', 'subject_ID', 't_cond', 'transducer_type')

end
