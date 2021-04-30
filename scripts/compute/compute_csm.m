function data_struct = compute_csm(eeg_raw, fs, am_freq, compute_opts)

n_column = size(eeg_raw, 2);

clip_len = compute_opts.clip_len;
n_segment = compute_opts.n_segment;

n_sample_subavg = floor(size(eeg_raw, 1) / n_segment);
n_sample_subavg = floor(n_sample_subavg/clip_len) * clip_len;
eeg_raw = eeg_raw(1:n_segment*n_sample_subavg, :);

f = fs * (0:1/clip_len:0.5)';
[~, f_mf] = min(abs(f-am_freq));
n_freq = length(f);

csm_mean = 1 / n_segment;
csm_std = sqrt((n_segment - 1) / (n_segment^3));
csm_thresh = csm_mean + 3 * csm_std;

csm = zeros(n_freq, n_column);
csm_mf = zeros(1, n_column);
for i = 1:n_column
    eeg_raw_column = eeg_raw(:,i);

    phi_mat = zeros(n_freq, n_segment);
    for j = 1:n_segment
        subavg_index = (1+(j-1)*n_sample_subavg):(j*n_sample_subavg);
        subavg_mat = reshape(eeg_raw_column(subavg_index), [clip_len, n_sample_subavg/clip_len]);
        subavg = mean(subavg_mat, 2);
        Y = fft(subavg);
        Y_angle = angle(Y);
        if rem(clip_len,2) == 0
            clip_sel = 1:clip_len/2+1;
        else
            clip_sel = 1:(clip_len+1)/2;
        end
        phi_mat(:, j) = Y_angle(clip_sel);
    end

    csm_column = zeros(n_freq, 1);
    for j = 1:n_freq
        csm_column(j) = mean(cos(phi_mat(j,:)))^2 + mean(sin(phi_mat(j,:)))^2;
    end

    csm(:,i) = csm_column;
    csm_mf(i) = csm_column(f_mf);
end

data_struct = struct();
data_struct.f = f;
data_struct.f_mf = f_mf;
data_struct.csm = csm;
data_struct.csm_mf = csm_mf;
data_struct.csm_thresh = csm_thresh;

end
