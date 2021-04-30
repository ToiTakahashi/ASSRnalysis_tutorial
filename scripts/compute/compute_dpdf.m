function data_struct = compute_dpdf(eeg_raw, fs, compute_opts)

n_column = size(eeg_raw, 2);

clip_len = compute_opts.clip_len;
clip_shift_step = compute_opts.clip_shift_step;
clip_shift_pattern = compute_opts.clip_shift_pattern;
use_matmul = compute_opts.use_matmul;

n_par = compute_opts.n_par;
poolobj = gcp('nocreate');
if isempty(poolobj), parpool('local', n_par); end

preproc_opts_1 = compute_opts.preproc_opts{1};
preproc_opts_2 = compute_opts.preproc_opts{2};
hist_div = compute_opts.hist_div;
hist_scaler = compute_opts.hist_scaler;
hist_opt = compute_opts.hist_opt;
eval_opt = compute_opts.eval_opt;

% DIV
dp_center = cell(clip_shift_pattern, n_column);
dp_hist = cell(clip_shift_pattern, n_column);
dp_div = cell(clip_shift_pattern, n_column);

dp_div_best = -1 * ones(1, n_column);
dp_div_best_idx = zeros(1, n_column);

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

        % DIV
        % dot product combination
        dp_mat = dpdf(data_mat, use_matmul);

        [dp_center_column, dp_hist_column]...
            = adjusted_hist_full(dp_mat, hist_div, hist_scaler, hist_opt);
        dp_center{csp, i} = dp_center_column;
        dp_hist{csp, i} = dp_hist_column;

        csp_cur_val_div = evaluate_dp_div_full(dp_center_column, dp_hist_column, eval_opt);

        % div log
        dp_div{csp, i} = csp_cur_val_div;
    end

    dp_div_column = [dp_div{:, i}];
    [ddb, ddbi] = max(dp_div_column);
    dp_div_best(i) = ddb;
    dp_div_best_idx(i) = ddbi;
end

data_struct = struct();
data_struct.dp_center = dp_center;
data_struct.dp_hist = dp_hist;
data_struct.dp_div = dp_div;
data_struct.dp_div_best = dp_div_best;
data_struct.dp_div_best_idx = dp_div_best_idx;

end
