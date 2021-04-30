function threshs = threshs_from_stats(repr, sil, data_type, n_thresh)

n_repr = length(repr);
n_sil = length(sil);
stats = [];
switch data_type
    case 'DPD'
        % `test_stat_dpd.m`
        % dp_div_best = data_struct.dp_div_best(c);
        for r = 1:n_repr
            stats = [stats, repr{r}.dp_div_best];
        end
        for s = 1:n_sil
            stats = [stats, sil{s}.dp_div_best];
        end
    case 'DPDf'
        % `test_stat_dpdf.m`
        % dp_div_best = data_struct.dp_div_best(c);
        for r = 1:n_repr
            stats = [stats, repr{r}.dp_div_best];
        end
        for s = 1:n_sil
            stats = [stats, sil{s}.dp_div_best];
        end
    case 'CSM'
        % `test_stat_csm.m`
        % csm_mf = data_struct.csm_mf(c);
        for r = 1:n_repr
            stats = [stats, repr{r}.csm_mf];
        end
        for s = 1:n_sil
            stats = [stats, sil{s}.csm_mf];
        end
    case 'MI'
        % `test_stat_mi.m`
        % dp_mi_best = data_struct.dp_mi_best(c);
        for r = 1:n_repr
            stats = [stats, repr{r}.dp_mi_best];
        end
        for s = 1:n_sil
            stats = [stats, sil{s}.dp_mi_best];
        end
end
stats_max = max(stats);
stats_min = min(stats);
stats_range = stats_max - stats_min;

threshs_min = stats_min - 0.1 * stats_range;
threshs_max = stats_max + 0.1 * stats_range;
threshs = linspace(threshs_min, threshs_max, n_thresh);

end
