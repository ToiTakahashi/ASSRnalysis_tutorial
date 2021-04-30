function [test_stat, test_stat_val] = test_stat_csm(data_struct, test_opt)

n_column = size(data_struct.csm_mf, 2);
test_stat = false(1, n_column);
test_stat_val = zeros(1, n_column);
for c = 1:n_column
    %% Load Data
    %f = data_struct.f;
    %f_mf = data_struct.f_mf;
    %csm = data_struct.csm(:,c);
    csm_mf = data_struct.csm_mf(c);
    %csm_thresh = data_struct.csm_thresh;

    %% Test
    % different gives 1
    switch test_opt.type
        case 'threshold'
            test_stat(c) = csm_mf > test_opt.thresh;
            test_stat_val(c) = csm_mf;
    end
end
end
