function eeg_processed = preproc_dpd_custom_1(eeg_raw, fs, preproc_opt)

switch preproc_opt.mode
    case 'raw'
        eeg_processed = eeg_raw;
    case 'filt'
        bpFilter = designfilt('bandpassfir', 'FilterOrder', preproc_opt.order,...
            'CutoffFrequency1', preproc_opt.mf - preproc_opt.cutoff,...
            'CutoffFrequency2', preproc_opt.mf + preproc_opt.cutoff,...
            'SampleRate', fs);
        eeg_processed = filtfilt(bpFilter, eeg_raw);
    case 'phase_w_filt'
        bpFilter = designfilt('bandpassfir', 'FilterOrder', preproc_opt.order,...
            'CutoffFrequency1', preproc_opt.mf - preproc_opt.cutoff,...
            'CutoffFrequency2', preproc_opt.mf + preproc_opt.cutoff,...
            'SampleRate', fs);
        eeg_filt = filtfilt(bpFilter, eeg_raw);
        eeg_hilbert = angle(hilbert(eeg_filt));
        %eeg_processed = unwrap(eeg_hilbert);
        eeg_processed = eeg_hilbert;
    case 'phase_wo_filt'
        eeg_hilbert = angle(hilbert(eeg_raw));
        %eeg_processed = unwrap(eeg_hilbert);
        eeg_processed = eeg_hilbert;
end
