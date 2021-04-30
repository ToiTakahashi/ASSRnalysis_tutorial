function metric = metrics(n_tp, n_fn, n_tn, n_fp)

metric = struct();
metric.tpr = n_tp/(n_tp+n_fn); % sensitivity, recall, true positive rate
metric.tnr = n_tn/(n_tn+n_fp); % specificity, true negative rate
metric.acc = (n_tp+n_tn)/(n_tp+n_fn+n_tn+n_fp); % accuracy
metric.fpr = n_fp/(n_tn+n_fp); % false positive rate
metric.pre = n_tp/(n_tp+n_fp); % precision
metric.F1 = 2*((metric.tpr*metric.pre)/(metric.tpr+metric.pre));
metric.BER = (1-(n_tp/(n_tp+n_fn)+n_tn/(n_tn+n_fp))/2); % balance error rate
metric.FDR = n_fp/(n_tp+n_fp); % false discovery rate

end
