function [n_subject, subjects_repr, subjects_sil, subject_r_idxs, subject_s_idxs] = independent_columns_ignoring_indiv(subjects)

[subjects_repr, subjects_sil] = independent_columns(subjects);
n_repr = length(subjects_repr);
n_sil = length(subjects_sil);
if n_repr <= n_sil
    n_subject = n_repr;
else
    n_subject = n_sil;
end
subject_r_idxs = cell(n_subject, 1);
subject_s_idxs = cell(n_subject, 1);
n_repr_per_subject = floor(n_repr/n_subject);
n_repr_left = n_repr - n_subject*n_repr_per_subject;
n_sil_per_subject = floor(n_sil/n_subject);
n_sil_left = n_sil - n_subject*n_sil_per_subject;
r_idx = 1;
s_idx = 1;
for s = 1:n_subject
    if n_repr_left > 0
        s_r_idxs = r_idx:(r_idx+n_repr_per_subject);
        n_repr_left = n_repr_left - 1;
    else
        s_r_idxs = r_idx:(r_idx+n_repr_per_subject-1);
    end
    if n_sil_left > 0
        s_s_idxs = s_idx:(s_idx+n_sil_per_subject);
        n_sil_left = n_sil_left - 1;
    else
        s_s_idxs = s_idx:(s_idx+n_sil_per_subject-1);
    end
    subject_r_idxs{s} = s_r_idxs;
    subject_s_idxs{s} = s_s_idxs;
    r_idx = s_r_idxs(end) + 1;
    s_idx = s_s_idxs(end) + 1;
end

end