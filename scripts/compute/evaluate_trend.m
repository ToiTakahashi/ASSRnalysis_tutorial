function data_trend = evaluate_trend(data_mat)
% TODO: linear regression?
n_clip = size(data_mat, 2);

data_trend = zeros(n_clip, 1);
for j = 1:n_clip
    cur_clip = data_mat(:, j);
    if cur_clip(1) <= cur_clip(end)
        data_trend(j) = 1;
    else
        data_trend(j) = -1;
    end
end

end
