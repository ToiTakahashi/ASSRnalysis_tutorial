function [metric_repr, best_ms, best_threshs, confu] = test_dpd_losocv(repr, sil, subject_r_idxs, subject_s_idxs, test_opt, threshs)

assert(length(subject_r_idxs)==length(subject_s_idxs))
n_subject = length(subject_r_idxs);
n_repr = length(repr);
sel_r = 1:n_repr;
n_sil = length(sil);
sel_s = 1:n_sil;
n_thresh = length(threshs);

n_tp = 0; n_fn = 0; n_tn = 0; n_fp = 0;
best_ms = zeros(n_subject, 1);
best_threshs = zeros(n_subject, 1);
confu = zeros(n_subject, 4);
for s = 1:n_subject
    r_idx = subject_r_idxs{s};
    s_idx = subject_s_idxs{s};
    repr_loo = repr(r_idx);
    sil_loo = sil(s_idx);
    repr_rem = repr(setdiff(sel_r, r_idx));
    sil_rem = sil(setdiff(sel_s, s_idx));
    [~, ~, ~, ms] = test_dpd(repr_rem, sil_rem, test_opt, threshs);
    ms_repr = zeros(n_thresh, 1);
    for m = 1:n_thresh
        ms_repr(m) = ms{m}.acc; % using accuracy
    end
    best_m = max(ms_repr);
    best_m_idxs = find(ms_repr==best_m);
    best_m_idx = round(median(best_m_idxs)); % heuristic
    best_thresh = threshs(best_m_idx);
    test_opt.thresh = best_thresh;

    n_rl = length(repr_loo);
    test_stat_1 = zeros(n_rl, 1);
    for rl = 1:n_rl
        test_stat_1(rl) = test_stat_dpd(repr_loo{rl}, test_opt);
    end
    s_n_tp = length(find(test_stat_1 == 1));
    s_n_fn = length(find(test_stat_1 == 0));

    n_sl = length(sil_loo);
    test_stat_0 = zeros(n_sl, 1);
    for sl = 1:n_sl
        test_stat_0(sl) = test_stat_dpd(sil_loo{sl}, test_opt);
    end
    s_n_tn = length(find(test_stat_0 == 0));
    s_n_fp = length(find(test_stat_0 == 1));

    best_ms(s) = best_m;
    best_threshs(s) = best_thresh;
    confu(s,1) = s_n_tp;
    confu(s,2) = s_n_fn;
    confu(s,3) = s_n_tn;
    confu(s,4) = s_n_fp;

    n_tp = n_tp + s_n_tp;
    n_fn = n_fn + s_n_fn;
    n_tn = n_tn + s_n_tn;
    n_fp = n_fp + s_n_fp;
end
metric = metrics(n_tp, n_fn, n_tn, n_fp);
metric_repr = metric.acc; % using accuracy

end
