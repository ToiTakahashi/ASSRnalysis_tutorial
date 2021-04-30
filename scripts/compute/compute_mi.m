function data_struct = compute_mi(eeg_raw, fs, compute_opts)

n_column = size(eeg_raw, 2);

clip_len = compute_opts.clip_len;
clip_shift_step = compute_opts.clip_shift_step;
clip_shift_pattern = compute_opts.clip_shift_pattern;

n_par = compute_opts.n_par;
poolobj = gcp('nocreate');
if isempty(poolobj), parpool('local', n_par); end

preproc_opts_1 = compute_opts.preproc_opts{1};
preproc_opts_2 = compute_opts.preproc_opts{2};

% MI
dp_mi = cell(clip_shift_pattern, n_column);
dp_seq = cell(clip_shift_pattern, n_column);
dp_mi_best = -1 * ones(1, n_column);
dp_mi_best_idx = zeros(1, n_column);

% prepare data
eeg_raw_mat = cell(clip_shift_pattern, n_column);
for i = 1:n_column
    for csp = 1:clip_shift_pattern
        eeg_raw_mat{csp, i} = eeg_raw((1+(csp-1)*clip_shift_step):end, i); % n sample decreases as you shift
    end
end

% compute in parallel
for i = 1:n_column
    parfor csp = 1:clip_shift_pattern
        eeg_raw_column = eeg_raw_mat{csp, i};
        n_data = size(eeg_raw_column, 1);
        n_clip = floor(n_data / clip_len);

        % introduce downsampling?
        eeg_processed_column = preproc_dpd_custom_1(eeg_raw_column, fs, preproc_opts_1);
        data_mat = zeros(floor(clip_len), n_clip);
        for clip_j = 1:n_clip
            cur_time_sel = clip_time(n_data, clip_len, clip_j);
            cur_data = eeg_processed_column(cur_time_sel);
            cur_data_proc = preproc_dpd_custom_2(cur_data, 1, floor(clip_len), preproc_opts_2);
            data_mat(:, clip_j) = cur_data_proc;
        end

        % MI
        data_trend = evaluate_trend(data_mat)
        csp_cur_val_mi = dpm(data_trend);

        dp_mi{csp, i} = csp_cur_val_mi;
        dp_seq{csp, i} = data_trend;
    end

    dp_mi_column = [dp_mi{:, i}];
    [dmb, dmbi] = max(dp_mi_column);
    dp_mi_best(i) = dmb;
    dp_mi_best_idx(i) = dmbi;
end

data_struct = struct();
data_struct.dp_mi = dp_mi;
data_struct.dp_seq = dp_seq;
data_struct.dp_mi_best = dp_mi_best;
data_struct.dp_mi_best_idx = dp_mi_best_idx;

end
