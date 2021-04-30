function [dp_mat_ii, dp_mat_dd, dp_mat_id] = dpd(data_mat, use_matmul)

n_clip = size(data_mat, 2);

clip_i = 1:2:n_clip;
clip_d = 2:2:n_clip;
% align length
if length(clip_i) > length(clip_d)
    clip_i = clip_i(1:end - 1);
end
n_subclip = length(clip_i);

if use_matmul
    triu_ind = false([n_subclip, n_subclip]);
    for m = 1:(n_subclip - 1)
        for mm = (m + 1):n_subclip
            triu_ind(m, mm) = true;
        end
    end
    dmii = data_mat(:, clip_i)' * data_mat(:, clip_i);
    dp_mat_ii = dmii(triu_ind);
    dmdd = data_mat(:, clip_d)' * data_mat(:, clip_d);
    dp_mat_dd = dmdd(triu_ind);
    dp_mat_id = reshape(data_mat(:, clip_i)' * data_mat(:, clip_d), [n_subclip * n_subclip, 1]);
else
    [n_comb, j_seq, k_seq, ~] = comb_index(n_subclip);
    dp_mat_ii = zeros(n_comb, 1);
    dp_mat_dd = zeros(n_comb, 1);
    for m = 1:n_comb
        data_i_j = data_mat(:, clip_i(j_seq(m)));
        data_i_k = data_mat(:, clip_i(k_seq(m)));
        % choose a measure of similarity
        dp_mat_ii(m) = data_i_j' * data_i_k;

        data_d_j = data_mat(:, clip_d(j_seq(m)));
        data_d_k = data_mat(:, clip_d(k_seq(m)));
        % choose a measure of similarity
        dp_mat_dd(m) = data_d_j' * data_d_k;
    end
    dp_mat_id = zeros(n_subclip * n_subclip, 1);
    for m = 1:n_subclip
        data_i_j = data_mat(:, clip_i(m));
        for mm = 1:n_subclip
            data_d_k = data_mat(:, clip_d(mm));
            % choose a measure of similarity
            dp_mat_id((m - 1) * n_subclip + mm) = data_i_j' * data_d_k;
        end

    end
end

end
