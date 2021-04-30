function data_mat_processed = preproc_dpd_custom_2(data_mat, n_clip, clip_len, preproc_opt)

data_mat_processed = zeros(size(data_mat));

switch preproc_opt.mode
    case 'raw'
        data_mat_processed = data_mat;
    case 'detrend_demean_normalize'
        X = [ones(clip_len, 1) (0:clip_len-1)'];
        for j = 1:n_clip
            Y = data_mat(:,j);
            B = X\Y;
            Y_hat = X*B;
            det_data = Y - Y_hat;
            data_mat_processed(:,j) = (det_data - mean(det_data)) / std(det_data);
        end
    case 'demean_normalize'
        for j = 1:n_clip
            det_data = data_mat(:,j);
            data_mat_processed(:,j) = (det_data - mean(det_data)) / std(det_data);
        end
end

end