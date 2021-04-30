function concatenate_subject(subject_mat_1, subject_mat_2, subject_ID)

subject_1 = load(subject_mat_1);
subject_2 = load(subject_mat_2);

assert(subject_1.am_freq==subject_2.am_freq);
assert(subject_1.fs==subject_2.fs);
assert(strcmp(subject_1.transducer_type, subject_2.transducer_type));

am_freq = subject_1.am_freq;
fs = subject_1.fs;
transducer_type = subject_1.transducer_type;

n_cond = subject_1.n_cond + subject_2.n_cond;
dur = [subject_1.dur, subject_2.dur];
t_cond = [subject_1.t_cond, subject_2.t_cond];
data_mat = [subject_1.data_mat, subject_2.data_mat];
freq_list = [subject_1.freq_list, subject_2.freq_list];
loud_list = [subject_1.loud_list, subject_2.loud_list];
cond_txt = [subject_1.cond_txt, subject_2.cond_txt];

save(subject_ID, 'am_freq', 'cond_txt', 'data_mat', 'dur', ...
    'freq_list', 'fs', 'loud_list', 'n_cond', 'subject_ID', 't_cond', 'transducer_type')

end
