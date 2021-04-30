%% Params
test_repr_util;

%% Multi
ms = zeros(n_dur, n_reprs);

for dur_idx = 1:n_dur

analysis_dur = analysis_durs(dur_idx);
analysis_txt = [num2str(analysis_dur) 's-MF' num2str(analysis_freq) 'Hz-'];
disp(analysis_txt)

%% Multi
for repr_idx = 1:n_reprs
    disp([num2str(repr_idx) '/' num2str(n_reprs)])

    f_repr = f_reprs(repr_idx);
    l_repr = l_reprs(repr_idx);

    %% Data
    subjects = load_repr(data_dir, f_repr, l_repr);
    subjects = split_subjects(subjects, analysis_dur);
    %n_subject = length(subjects); % same as # of mat files

    % single column
    %[subjects_repr, subjects_sil, subject_r_idxs, subject_s_idxs] = independent_columns(subjects);
    [n_subject, subjects_repr, subjects_sil, subject_r_idxs, subject_s_idxs] = independent_columns_ignoring_indiv(subjects);
    assert(n_subject >= 2)

    n_repr = length(subjects_repr);
    n_sil = length(subjects_sil);

    %% Analyze CSM
    disp('CSM')
    data_type = 'CSM';
    compute_opts.clip_len = clip_len_csm;

    repr = cell(n_repr, 1);
    for s = 1:n_repr
        disp([' r' num2str(s) '/' num2str(n_repr)])
        subject = subjects_repr{s};
        repr{s} = compute_csm(subject.data_repr, subject.fs, subject.am_freq, compute_opts);
    end

    sil = cell(n_sil, 1);
    for s = 1:n_sil
        disp([' s' num2str(s) '/' num2str(n_sil)])
        subject = subjects_sil{s};
        sil{s} = compute_csm(subject.data_sil, subject.fs, subject.am_freq, compute_opts);
    end

    %% Test CSM
    disp('TEST')

    threshs = threshs_from_stats(repr, sil, data_type, n_thresh);
    [metric_repr, best_ms, best_threshs] = test_csm_losocv(repr, sil, subject_r_idxs, subject_s_idxs, test_opt, threshs);

    % use original threshold
    %csm_thresh = repr{1}.csm_thresh;
    %[metric_repr_csm, best_ms_csm, best_threshs_csm] = test_csm_losocv(repr, sil, subject_r_idxs, subject_s_idxs, test_opt, csm_thresh);

    ms(dur_idx, repr_idx) = metric_repr;

    %%
    model_ids_c = {'CSM'};

    model_ids = categorical(model_ids_c);
    cdata_base = [[0.3010,0.7450,0.9330];[0,0.4470,0.7410];[0.9290,0.6940,0.1250];[0.8500,0.3250,0.0980];
                  [0.4940,0.1840,0.5560];[0.4660,0.6740,0.1880];[0.6350,0.0780,0.1840];[0,0,0]];
    cdata = cdata_base(6, :);

    fig = figure();
    axs = gobjects(1, 3);
    ax(1) = subplot(1,3,1);
    b = bar(model_ids, metric_repr, 'FaceColor', 'flat');
    b.CData = cdata;
    ylim([0, 1])
    grid on; grid minor;
    fig_title_1 = 'CV Acc(validation)';
    title(fig_title_1)
    ax(2) = subplot(1,3,2);
    boxplot(best_ms, 'notch', 'on', 'labels', model_ids_c)
    ylim([0, 1])
    grid on; grid minor;
    fig_title_2 = 'CV Acc(train)';
    title(fig_title_2)
    ax(3) = subplot(1,3,3);
    boxplot(best_threshs, 'notch', 'on', 'labels', model_ids_c)
    fig_title_3 = 'selected thresholds';
    title(fig_title_3)
    tunefig('document', fig)

    fig_title = [num2str(analysis_dur) 's-MF' num2str(analysis_freq) 'Hz-ACC4' data_type num2str(f_repr) 'Hz' num2str(l_repr) 'dB'];
    fig_filename = [fig_dir filesep fig_title '.fig'];
    savefig(fig_filename)
end
end

% analysis_durs', l_reprs, ms
ms = struct('ms', ms, 'type', 'CSM');
