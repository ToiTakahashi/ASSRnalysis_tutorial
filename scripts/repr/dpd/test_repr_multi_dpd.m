%% Params
test_repr_util;

%% Multi
aucs = zeros(n_dur, n_reprs);

for dur_idx = 1:n_dur

analysis_dur = analysis_durs(dur_idx);
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

%% Multi
for repr_idx = 1:n_reprs
    disp([num2str(repr_idx) '/' num2str(n_reprs)])

    f_repr = f_reprs(repr_idx);
    l_repr = l_reprs(repr_idx);

    %% Data
    subjects = load_repr(data_dir, f_repr, l_repr);
    subjects = split_subjects(subjects, analysis_dur);
    n_data = length(subjects);

    %% Analyze DPD
    disp('DPD')
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
    aucs(dur_idx, repr_idx) = auc_val;
    auc_txt = ['(AUC:' num2str(auc_val, '%.3f') ')'];

    figure(f_dpd)
    cond_str = [num2str(l_repr) 'dB' auc_txt];
    plot(fprs, tprs, 'o-', 'DisplayName', cond_str)

end

figure(f_dpd)
legend('Location', 'SouthEast')
tunefig('document', gcf)
fig_filename_dpd = [fig_dir filesep fig_title_dpd '.fig'];
savefig(fig_filename_dpd)

end

% analysis_durs', l_reprs, aucs
aucs = struct('aucs', aucs, 'type', 'DPD');
