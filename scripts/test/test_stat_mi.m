function [test_stat, test_stat_val] = test_stat_mi(data_struct, test_opt)

n_column = size(data_struct.dp_mi, 2);
test_stat = false(1, n_column);
test_stat_val = zeros(1, n_column);
for c = 1:n_column
    %% Load Data
    %dp_mi = [data_struct.dp_mi{:,c}];
    %dp_seq = data_struct.dp_seq(:,c);
    dp_mi_best = data_struct.dp_mi_best(c);
    %dp_mi_best_idx = data_struct.dp_mi_best_idx(c);

    %% Test
    % different gives 1
    switch test_opt.type
        case 'threshold'
            test_stat(c) = dp_mi_best > test_opt.thresh;
            test_stat_val(c) = dp_mi_best;
    end
end
end
