function val_div = evaluate_dp_div(dp_center, dp_hist_ii, dp_hist_dd, dp_hist_id, dp_hist_item_min, eval_opt)

switch eval_opt
    case 'RMS'
        val_div_sub_ii_id_diff = dp_hist_ii - dp_hist_id;
        val_div_sub_dd_id_diff = dp_hist_dd - dp_hist_id;
        val_div_sub_ii_id = sqrt(mean(val_div_sub_ii_id_diff .* val_div_sub_ii_id_diff)) / dp_hist_item_min;
        val_div_sub_dd_id = sqrt(mean(val_div_sub_dd_id_diff .* val_div_sub_dd_id_diff)) / dp_hist_item_min;
        val_div = (val_div_sub_ii_id + val_div_sub_dd_id) / 2;
    case 'fKL'
        dist_ii = KLDiv(dp_hist_id, dp_hist_ii);
        dist_dd = KLDiv(dp_hist_id, dp_hist_dd);
        val_div = (dist_ii + dist_dd)/2;
    case 'rKL'
        dist_ii = KLDiv(dp_hist_ii, dp_hist_id);
        dist_dd = KLDiv(dp_hist_dd, dp_hist_id);
        val_div = (dist_ii + dist_dd)/2;
    case 'JS'
        dist_ii = JSDiv(dp_hist_ii, dp_hist_id);
        dist_dd = JSDiv(dp_hist_dd, dp_hist_id);
        val_div = (dist_ii + dist_dd)/2;
end

end
