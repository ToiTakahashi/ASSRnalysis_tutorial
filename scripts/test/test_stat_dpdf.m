function [test_stat, test_stat_val] = test_stat_dpdf(data_struct, test_opt)

n_column = size(data_struct.dp_div_best, 2);
test_stat = false(1, n_column);
test_stat_val = zeros(1, n_column);
for c = 1:n_column
    %% Load Data: Use Function
    dp_div = data_struct.dp_div(:,c);
    n_shifts = length(dp_div);
    dp = zeros(n_shifts, 1);
    for i = 1:n_shifts
        dp(i) = dp_div{i};
    end

    n_div = length(data_struct.dp_center{1});
    dp_center = zeros(n_shifts, n_div);
    dp_hist = zeros(n_shifts, n_div);
    for i = 1:n_shifts
        dp_center(i,:) = data_struct.dp_center{i,c};
        dp_hist(i,:) = data_struct.dp_hist{i,c};
    end

    %% Best DIV
    dp_div_best = data_struct.dp_div_best(c);
    %dp_div_best_idx = data_struct.dp_div_best_idx(c);
    %dp_center_best = squeeze(dp_center(dp_div_best_idx,:))';
    %dp_hist_best = squeeze(dp_hist(dp_div_best_idx,:))';

    %% Test
    % different gives 1
    switch test_opt.type
        case 'threshold'
            test_stat(c) = dp_div_best > test_opt.thresh;
            test_stat_val(c) = dp_div_best;
    end
end
end
