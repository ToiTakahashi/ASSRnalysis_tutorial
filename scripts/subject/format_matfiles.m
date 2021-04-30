%%
% Requirements
% - load_repr:
%     am_freq, fs, dur, data_mat, freq_list, loud_list

clear;
mat_filename = '';
load(mat_filename)
% data_mat is cell matrix. dur is matrix.
save(mat_filename, 'am_freq', 'data_mat', 'dur', 'freq_list', 'fs', 'loud_list')

%%
% Requirements
% - concatenate_subject:
%     am_freq, fs, transducer_type, n_cond, dur, t_cond, data_mat, freq_list, loud_list, cond_txt

clear;
subject_ID = 'N/A';
transducer_type = 'N/A';
mat_filename = '';
load(mat_filename)
% data_mat, t_cond is cell matrix. dur is matrix.
save(mat_filename, 'am_freq', 'cond_txt', 'data_mat', 'dur', ...
    'freq_list', 'fs', 'loud_list', 'n_cond', 'subject_ID', 't_cond', 'transducer_type')
% silence first as a norm
subject_mat_1 = '';
subject_mat_2 = '';
subject_ID = '';
concatenate_subject(subject_mat_1, subject_mat_2, subject_ID)
