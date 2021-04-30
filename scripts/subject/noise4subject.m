function subject_wn = noise4subject(subject, noise_level)

subject_wn = subject; % copy?

[n_sample_repr, n_column_repr] = size(subject.data_repr);
for r = 1:n_column_repr
    subject_wn.data_repr(:, r) = subject.data_repr(:, r) + noise_level*randn(n_sample_repr, 1);
end
[n_sample_sil, n_column_sil] = size(subject.data_sil);
for s = 1:n_column_sil
    subject_wn.data_sil(:, s) = subject.data_sil(:, s) + noise_level*randn(n_sample_sil, 1);
end

end