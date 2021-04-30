function sort_subject(subject_mat, idxs)

subject = load(subject_mat);

am_freq = subject.am_freq;
fs = subject.fs;
subject_ID = subject.subject_ID;
transducer_type = subject.transducer_type;

n_cond = subject.n_cond;

cond_txt_pre = subject.cond_txt;
cond_txt = cond_txt_pre(idxs);
disp(cond_txt_pre)
disp('->')
disp(cond_txt)

dur = subject.dur(idxs);
t_cond = subject.t_cond(idxs);
data_mat = subject.data_mat(idxs);
freq_list = subject.freq_list(idxs);
loud_list = subject.loud_list(idxs);

filename = ['sorted-' subject_mat];
save(filename, 'am_freq', 'cond_txt', 'data_mat', 'dur', ...
    'freq_list', 'fs', 'loud_list', 'n_cond', 'subject_ID', 't_cond', 'transducer_type')

end
