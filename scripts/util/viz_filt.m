function viz_filt(eeg_pre, fs, preproc_opt)

%{
% Test Case
dur = 30;
fs = 500;
n_sample = round(dur*fs);
eeg_pre = randn(n_sample, 1);
preproc_opt = struct();
preproc_opt.order = fs*1000/1000;
preproc_opt.mf = 40;
preproc_opt.cutoff = 0.5;
%}

bpFilter = designfilt('bandpassfir', 'FilterOrder', preproc_opt.order,...
            'CutoffFrequency1', preproc_opt.mf - preproc_opt.cutoff,...
            'CutoffFrequency2', preproc_opt.mf + preproc_opt.cutoff,...
            'SampleRate', fs);
fvtool(bpFilter)

[f_pre, P1_pre] = ret_fft(eeg_pre, fs);
eeg_post = filtfilt(bpFilter, eeg_pre);
[f_post, P1_post] = ret_fft(eeg_post, fs);

figure; hold on;
semilogy(f_pre', P1_pre, 'k', 'DisplayName', 'pre')
semilogy(f_post', P1_post, 'r', 'DisplayName', 'post')
hold off
xlabel('[Hz]')
ylabel('[AU]')
xlim([0, 80])

end
