function [subjects_repr, subjects_sil, subject_r_idxs, subject_s_idxs] = independent_columns(subjects)

n_subject = length(subjects);
subject_r_idxs = cell(n_subject, 1);
subject_s_idxs = cell(n_subject, 1);

% seperate subject columns
subjects_repr = {};
subjects_sil = {};
repr_count = 1;
sil_count = 1;
for s = 1:n_subject
    subject = subjects{s};
    s_tmp = struct();
    s_tmp.fs = subject.fs;
    s_tmp.am_freq = subject.am_freq;

    n_repr = size(subject.data_repr, 2);
    for sr = 1:n_repr
        s_tmp_repr_c = s_tmp;
        s_tmp_repr_c.dur_repr = subject.dur_repr;
        s_tmp_repr_c.data_repr = subject.data_repr(:, sr);
        subjects_repr = [subjects_repr; s_tmp_repr_c];
    end
    subject_r_idxs{s} = repr_count:(repr_count+n_repr-1);
    repr_count = repr_count + n_repr;

    n_sil = size(subject.data_sil, 2);
    for ss = 1:n_sil
        s_tmp_sil_c = s_tmp;
        s_tmp_sil_c.dur_sil = subject.dur_sil;
        s_tmp_sil_c.data_sil = subject.data_sil(: ,ss);
        subjects_sil = [subjects_sil; s_tmp_sil_c];
    end
    subject_s_idxs{s} = sil_count:(sil_count+n_sil-1);
    sil_count = sil_count + n_sil;
end

end
