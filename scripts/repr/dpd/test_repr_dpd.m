%% Params
test_repr_util;

%% Data
subjects = load_repr(data_dir, f_repr, l_repr);
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

figure()
plot(fprs, tprs, 'ro-')
hold on
plot([0;1],[0;1],'k--')
hold off
fig_title = [num2str(analysis_dur) 's' 'ROC4' data_type '(' test_opt.type ')' num2str(f_repr) 'Hz' num2str(l_repr) 'dB'];
title(fig_title)
xlabel('FPR[-]')
ylabel('TPR[-]')
xlim([0, 1])
ylim([0, 1])
dim = [.6, .1, .1, .1];
auc_txt = ['AUC: ' num2str(auc_val)];
annotation('textbox', dim, 'String', auc_txt, 'FitBoxToText', 'on');
tunefig('document', gcf)
fig_filename = [fig_dir filesep fig_title '.fig'];
savefig(fig_filename)
