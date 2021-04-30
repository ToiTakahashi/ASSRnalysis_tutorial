%% Params
test_repr_util;

%% Multi
aucs_dpd = zeros(n_dur, n_reprs);
aucs_csm = zeros(n_dur, n_reprs);

% loop of analysis_duration (10s, 30s, 60s, 99s, ...)
for dur_idx = 1:n_dur

analysis_dur = analysis_durs(dur_idx); % ex) 30s
analysis_txt = [num2str(analysis_dur) 's-MF' num2str(analysis_freq) 'Hz-'];
disp(analysis_txt)

%% Figs
f_dpd = figure('Name', 'dpd');
hold on
plot([0;1], [0;1], 'k--', 'DisplayName', '')
xlim([0, 1])
ylim([0, 1])
data_type = 'DPD';
fig_title_dpd = [analysis_txt 'ROC4' data_type '(' test_opt.type ')CF' num2str(f_reprs(1)) 'Hz'];
title(fig_title_dpd)
xlabel('FPR[-]')
ylabel('TPR[-]')


f_csm = figure('Name', 'csm');
hold on
plot([0;1], [0;1], 'k--', 'DisplayName', '')
xlim([0, 1])
ylim([0, 1])
data_type = 'CSM';
fig_title_csm = [analysis_txt 'ROC4' data_type '(' test_opt.type ')CF' num2str(f_reprs(1)) 'Hz'];
title(fig_title_csm)
xlabel('FPR[-]')
ylabel('TPR[-]')



%% Multi
% loop of conditions ((500Hz,30dB), (500Hz,20dB), ...)
for repr_idx = 1:n_reprs
    disp([num2str(repr_idx) '/' num2str(n_reprs)])

    f_repr = f_reprs(repr_idx);
    l_repr = l_reprs(repr_idx);

    %% Data
    % subjects is a list of subject data.
    % subject data contains 'am_freq', 'dur_repr', 'data_repr', and so on.
    subjects = load_repr(data_dir, f_repr, l_repr);
    
    % Split 'data_repr' & 'data_sil' reffering to 'analysis_dur' & 'fs'.
    % transforming example:
    % 'data_repr': (149500 x 1) -> (15000 x 9)
    % 'data_sil': (299500 x 1) -> (15000 x 19)
    % 'dur_repr': 299 -> 30
    % 'dur_sil': 599 -> 30
    subjects = split_subjects(subjects, analysis_dur);
    
    n_data = length(subjects);

    %% Analyze DPD
    disp('DPD')
    data_type = 'DPD';
    compute_opts.clip_len = clip_len_corr;

    repr = cell(n_data, 1);
    sil = cell(n_data, 1);
    for s = 1:n_data
        disp([' ' num2str(s) '/' num2str(n_data)])
        subject = subjects{s};
        repr{s} = compute_dpd(subject.data_repr, subject.fs, compute_opts);
        sil{s} = compute_dpd(subject.data_sil, subject.fs, compute_opts);
    end

    %% Test DPD
    disp('TEST')

    threshs = threshs_from_stats(repr, sil, data_type, n_thresh);
    [tprs, fprs, tsvs] = test_dpd(repr, sil, test_opt, threshs);
    auc_val = auc(tprs, fprs);
    aucs_dpd(dur_idx, repr_idx) = auc_val;
    auc_txt = ['(AUC:' num2str(auc_val, '%.3f') ')'];

    figure(f_dpd)
    cond_str = [num2str(l_repr) 'dB' auc_txt];
    plot(fprs, tprs, 'o-', 'DisplayName', cond_str)

    %% Analyze CSM
    
    disp('CSM')
    data_type = 'CSM';
    compute_opts.clip_len = clip_len_csm;

    repr = cell(n_data, 1);
    sil = cell(n_data, 1);
    for s = 1:n_data
        disp([' ' num2str(s) '/' num2str(n_data)])
        subject = subjects{s};
        repr{s} = compute_csm(subject.data_repr, subject.fs, subject.am_freq, compute_opts);
        sil{s} = compute_csm(subject.data_sil, subject.fs, subject.am_freq, compute_opts);
    end

    %% Test CSM
    disp('TEST')

    threshs = threshs_from_stats(repr, sil, data_type, n_thresh);
    [tprs, fprs, tsvs] = test_csm(repr, sil, test_opt, threshs);
    auc_val = auc(tprs, fprs);
    aucs_csm(dur_idx, repr_idx) = auc_val;
    auc_txt = ['(AUC:' num2str(auc_val, '%.3f') ')'];

    figure(f_csm)
    cond_str = [num2str(l_repr) 'dB' auc_txt];
    plot(fprs, tprs, 'o-', 'DisplayName', cond_str)
    

end

figure(f_dpd)
legend('Location', 'SouthEast')
tunefig('document', gcf)
fig_filename_dpd = [fig_dir filesep fig_title_dpd '.fig'];
savefig(fig_filename_dpd)


figure(f_csm)
legend('Location', 'SouthEast')
fig_filename_csm = [fig_dir filesep fig_title_csm '.fig'];
tunefig('document', gcf)
savefig(fig_filename_csm)


end

% assume same f_repr
fig_title = ['AUC-fs' num2str(data_fs) '-MF' num2str(analysis_freq) '-CF' num2str(f_reprs(1))];
aucs_1 = struct('aucs', aucs_csm, 'type', 'CSM');
aucs_2 = struct('aucs', aucs_dpd, 'type', 'DPD');
compare_aucs(analysis_durs', l_reprs, aucs_1, aucs_2, fig_title, fig_dir)
