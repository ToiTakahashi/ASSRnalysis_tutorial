function [tprs, fprs, tsvs, ms] = test_dpd(data_1, data_0, test_opt, threshs)

n_data_1 = length(data_1);
n_data_0 = length(data_0);

n_thresh = length(threshs);
tprs = zeros(n_thresh, 1);
fprs = zeros(n_thresh, 1);
tsvs = cell(n_thresh, 2);
ms = cell(n_thresh, 1);
for t = 1:n_thresh
    test_opt.thresh = threshs(t);
    test_stat_1 = [];
    test_stat_0 = [];
    test_stat_val_1 = [];
    test_stat_val_0 = [];
    for s1 = 1:n_data_1
        [ts1s, tsv1s] = test_stat_dpd(data_1{s1}, test_opt);
        test_stat_1 = [test_stat_1, ts1s];
        test_stat_val_1 = [test_stat_val_1, tsv1s];
    end
    n_tp = length(find(test_stat_1 == 1));
    n_fn = length(find(test_stat_1 == 0));
    for s0 = 1:n_data_0
        [ts0s, tsv0s] = test_stat_dpd(data_0{s0}, test_opt);
        test_stat_0 = [test_stat_0, ts0s];
        test_stat_val_0 = [test_stat_val_0, tsv0s];
    end
    n_tn = length(find(test_stat_0 == 0));
    n_fp = length(find(test_stat_0 == 1));
    metric = metrics(n_tp, n_fn, n_tn, n_fp);

    tprs(t) = metric.tpr;
    fprs(t) = metric.fpr;
    tsvs{t,1} = test_stat_val_1;
    tsvs{t,2} = test_stat_val_0;
    ms{t} = metric;
end
end
