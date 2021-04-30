%% Params
data_dir = ['datamats' filesep 'datamat_rion'];
subject_idx = 1;

f_repr = -1;
l_repr = 70;

subjects = load_repr(data_dir, f_repr, l_repr);
subject = subjects{subject_idx};

fs = subject.fs;
analysis_freqs = 30:1:48; % natural numbers <- `clip_len_csm` is 1000ms
%analysis_freqs = 80:1:100; % natural numbers <- `clip_len_csm` is 1000ms
% 1000ms -> 1Hz resolution starting from 0Hz
switch fs
    case 500
        clip_len_csm = 500; % 1000ms, 500Hz
    case 20000
        clip_len_csm = 20000; % 1000ms, 20000Hz
end

n_segment = 10;

compute_opts = struct();
compute_opts.clip_len = clip_len_csm;
compute_opts.n_segment = n_segment;

%% Analyze

n_af = length(analysis_freqs);
csms_repr = cell(n_af, 1);
csms_sil = cell(n_af, 1);
for af = 1:n_af
    csms_repr{af} = compute_csm(subject.data_repr, fs, analysis_freqs(af), compute_opts);
    csms_sil{af} = compute_csm(subject.data_sil, fs, analysis_freqs(af), compute_opts);
end

%% Plot repr

figure(); hold on
for af = 1:n_af
    f = csms_repr{af}.f(csms_repr{af}.f_mf);
    csm_mf = csms_repr{af}.csm_mf;
    csm_thresh = csms_repr{af}.csm_thresh;
    if csm_mf > csm_thresh
        af_color = 'r';
    else
        af_color = 'k';
    end
    bar(f, csm_mf, af_color)
    plot(f, csm_thresh, 'bx')
end
hold off
ylim([0 1])
fig_title = ['CF' num2str(f_repr) 'Hz' num2str(l_repr) 'dB' '-fs' num2str(fs) '.fig'];
title(fig_title)
tunefig('document', gcf)
%%
savefig(fig_title)

%% Plot sil
%{
figure(); hold on
for af = 1:n_af
    f = csms_sil{af}.f(csms_sil{af}.f_mf);
    csm_mf = csms_sil{af}.csm_mf;
    csm_thresh = csms_sil{af}.csm_thresh;
    if csm_mf > csm_thresh
        af_color = 'r';
    else
        af_color = 'k';
    end
    bar(f, csm_mf, af_color)
    plot(f, csm_thresh, 'bx')
end
hold off
ylim([0 1])
fig_title = ['CF' '-1' 'Hz' '-1' 'dB' '-fs' num2str(fs) '.fig'];
title(fig_title)
tunefig('document', gcf)
%%
savefig(fig_title)
%}
