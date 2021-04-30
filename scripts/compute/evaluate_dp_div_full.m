function val_div = evaluate_dp_div_full(dp_center, dp_hist, eval_opt)

switch eval_opt
    case 'CR'
        pos_sel = (dp_center>0);
        neg_sel = (dp_center<0);
        pos_area = sum(dp_hist(pos_sel));
        neg_area = sum(dp_hist(neg_sel));
        val_div = pos_area/neg_area;
end

end
