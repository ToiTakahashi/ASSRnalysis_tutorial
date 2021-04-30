function subjects_split = split_subjects(subjects, analysis_dur)

n_subject = length(subjects);

% split subject data into columns
subjects_split = cell(size(subjects));
for s = 1:n_subject
    subject = subjects{s};
    s_tmp = struct();
    s_tmp.fs = subject.fs;
    analysis_sample = floor(analysis_dur*s_tmp.fs);
    s_tmp.am_freq = subject.am_freq;

    n_repr = floor(subject.dur_repr/analysis_dur);
    if n_repr == 0
        s_tmp.dur_repr = subject.dur_repr;
        s_tmp.data_repr = subject.data_repr;
    else
        s_tmp.dur_repr = analysis_dur;
        data_repr = subject.data_repr(1:n_repr*analysis_sample);
        s_tmp.data_repr = reshape(data_repr, [analysis_sample, n_repr]);
    end

    n_sil = floor(subject.dur_sil/analysis_dur);
    if n_sil == 0
        s_tmp.dur_sil = subject.dur_sil;
        s_tmp.data_sil = subject.data_sil;
    else
        s_tmp.dur_sil = analysis_dur;
        data_sil = subject.data_sil(1:n_sil*analysis_sample);
        s_tmp.data_sil = reshape(data_sil, [analysis_sample, n_sil]);
    end

    subjects_split{s} = s_tmp;
end

end
