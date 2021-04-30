%% Params
test_repr_util;

noise_levels = 0:5:40;
n_noise = length(noise_levels);

%% Multi
for analysis_dur = analysis_durs

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

%{
f_mi = figure('Name', 'mi');
hold on
plot([0;1], [0;1], 'k--', 'DisplayName', '')
xlim([0, 1])
ylim([0, 1])
data_type = 'MI';
fig_title_mi = [analysis_txt 'ROC4' data_type '(' test_opt.type ')CF' num2str(f_reprs(1)) 'Hz'];
title(fig_title_mi)
xlabel('FPR[-]')
ylabel('TPR[-]')
%}

%% Multi
for repr_idx = 1:n_reprs

disp([' r ' num2str(repr_idx) '/' num2str(n_reprs)])

f_repr = f_reprs(repr_idx);
l_repr = l_reprs(repr_idx);

%% Multi
aucs_dpd = zeros(1, n_noise);
aucs_csm = zeros(1, n_noise);
%aucs_mi = zeros(1, n_noise);
for noise_idx = 1:n_noise

disp(['   n ' num2str(noise_idx) '/' num2str(n_noise)])

noise_level = noise_levels(noise_idx);
noise_txt = ['[n' num2str(noise_level) ']'];

%% Data
subjects = load_repr(data_dir, f_repr, l_repr);
subjects = split_subjects(subjects, analysis_dur);
subjects = noise4subjects(subjects, noise_level);
n_data = length(subjects);

%% Analyze DPD
disp('    DPD')
data_type = 'DPD';
compute_opts.clip_len = clip_len_corr;

repr = cell(n_data, 1);
sil = cell(n_data, 1);
for s = 1:n_data
    disp(['     s ' num2str(s) '/' num2str(n_data)])
    subject = subjects{s};
    repr{s} = compute_dpd(subject.data_repr, subject.fs, compute_opts);
    sil{s} = compute_dpd(subject.data_sil, subject.fs, compute_opts);
end

%% Test DPD
disp('     TEST')

threshs = threshs_from_stats(repr, sil, data_type, n_thresh);
[tprs, fprs, tsvs] = test_dpd(repr, sil, test_opt, threshs);
auc_val = auc(tprs, fprs);
aucs_dpd(noise_idx) = auc_val;
auc_txt = ['(AUC:' num2str(auc_val, '%.3f') ')'];

figure(f_dpd)
cond_str = [num2str(l_repr) 'dB' noise_txt auc_txt];
plot(fprs, tprs, 'o-', 'DisplayName', cond_str)

%% Analyze CSM
disp('    CSM')
data_type = 'CSM';
compute_opts.clip_len = clip_len_csm;

repr = cell(n_data, 1);
sil = cell(n_data, 1);
for s = 1:n_data
    disp(['     s ' num2str(s) '/' num2str(n_data)])
    subject = subjects{s};
    repr{s} = compute_csm(subject.data_repr, subject.fs, subject.am_freq, compute_opts);
    sil{s} = compute_csm(subject.data_sil, subject.fs, subject.am_freq, compute_opts);
end

%% Test CSM
disp('     TEST')

threshs = threshs_from_stats(repr, sil, data_type, n_thresh);
[tprs, fprs, tsvs] = test_csm(repr, sil, test_opt, threshs);
auc_val = auc(tprs, fprs);
aucs_csm(noise_idx) = auc_val;
auc_txt = ['(AUC:' num2str(auc_val, '%.3f') ')'];

figure(f_csm)
cond_str = [num2str(l_repr) 'dB' noise_txt auc_txt];
plot(fprs, tprs, 'o-', 'DisplayName', cond_str)

%{
%% Analyze MI
disp('    MI')
data_type = 'MI';
compute_opts.clip_len = clip_len_corr;

repr = cell(n_data, 1);
sil = cell(n_data, 1);
for s = 1:n_data
    disp(['     s ' num2str(s) '/' num2str(n_data)])
    subject = subjects{s};
    repr{s} = compute_mi(subject.data_repr, subject.fs, compute_opts);
    sil{s} = compute_mi(subject.data_sil, subject.fs, compute_opts);
end

%% Test MI
disp('     TEST')

threshs = threshs_from_stats(repr, sil, data_type, n_thresh);
[tprs, fprs, tsvs] = test_mi(repr, sil, test_opt, threshs);
auc_val = auc(tprs, fprs);
aucs_mi(noise_idx) = auc_val;
auc_txt = ['(AUC:' num2str(auc_val, '%.3f') ')'];

figure(f_mi)
cond_str = [num2str(l_repr) 'dB' noise_txt auc_txt];
plot(fprs, tprs, 'o-', 'DisplayName', cond_str)

%}

end

fig_title = ['AUC-fs' num2str(data_fs) '-MF' num2str(analysis_freq) '-CF' num2str(f_repr) '-' num2str(l_repr) 'dB-' num2str(analysis_dur) 's'];
aucs_1 = struct('aucs', aucs_csm, 'type', 'CSM');
aucs_2 = struct('aucs', aucs_dpd, 'type', 'DPD');
compare_aucs_noisy(noise_levels, aucs_1, aucs_2, fig_title, fig_dir)

fig = figure(f_dpd);
legend('Location', 'SouthEast')
tunefig('document', fig)
fig_filename_dpd = [fig_dir filesep fig_title_dpd '.fig'];
savefig(fig_filename_dpd)

fig = figure(f_csm);
legend('Location', 'SouthEast')
fig_filename_csm = [fig_dir filesep fig_title_csm '.fig'];
tunefig('document', fig)
savefig(fig_filename_csm)

%{
fig = figure(f_mi);
legend('Location', 'SouthEast')
fig_filename_mi = [fig_dir filesep fig_title_mi '.fig'];
tunefig('document', fig)
savefig(fig_filename_mi)
%}

end
end
