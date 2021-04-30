function dp_mat = dpdf(data_mat, use_matmul)

n_clip = size(data_mat, 2);

if use_matmul
    triu_ind = false([n_clip, n_clip]);
    for m = 1:(n_clip - 1)
        for mm = (m + 1):n_clip
            triu_ind(m, mm) = true;
        end
    end
    dm = data_mat' * data_mat;
    dp_mat = dm(triu_ind);
else
    [n_comb, j_seq, k_seq, ~] = comb_index(n_clip);
    dp_mat = zeros(n_comb, 1);
    for m = 1:n_comb
        data_j = data_mat(:, j_seq(m));
        data_k = data_mat(:, k_seq(m));
        % choose a measure of similarity
        dp_mat(m) = data_j' * data_k;
    end
end

end
