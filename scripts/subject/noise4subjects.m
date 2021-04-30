function subjects_wn = noise4subjects(subjects, noise_level)

n_subject = length(subjects);
subjects_wn = cell(size(subjects));
for s = 1:n_subject
    subject = subjects{s};
    subject_wn = noise4subject(subject, noise_level);
    subjects_wn{s} = subject_wn;
end

end