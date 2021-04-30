function [dp_center, dp_hist_ii, dp_hist_dd, dp_hist_id, dp_hist_item_min] = adjusted_hist(dp_mat_ii, dp_mat_dd, dp_mat_id, hist_div, hist_scaler, hist_opt)

hist_elem = hist_scaler / (hist_div - 1);
hist_edge = -(hist_scaler / 2 + hist_elem):hist_elem:(hist_scaler / 2 + hist_elem);
hist_edge_c = hist_edge(1:end - 1) + hist_elem / 2;
dp_center = hist_edge(2:end - 1);

% choose a method of visualization
switch hist_opt
    case 'raw'
        dp_hist_ii = histcounts(dp_mat_ii, hist_edge_c);
        dp_hist_dd = histcounts(dp_mat_dd, hist_edge_c);
        dp_hist_id = histcounts(dp_mat_id, hist_edge_c);

        % Equalize the total number of items
        dp_hist_item_ii = sum(dp_hist_ii);
        dp_hist_item_dd = sum(dp_hist_dd);
        dp_hist_item_id = sum(dp_hist_id);
        dp_hist_item_min = min([dp_hist_item_ii, dp_hist_item_dd, dp_hist_item_id]);
        dp_hist_scaler_ii = dp_hist_item_ii / dp_hist_item_min;
        dp_hist_scaler_dd = dp_hist_item_dd / dp_hist_item_min;
        dp_hist_scaler_id = dp_hist_item_id / dp_hist_item_min;
    case 'pdf'
        dp_hist_ii = histcounts(dp_mat_ii, hist_edge_c, 'Normalization', 'pdf');
        dp_hist_dd = histcounts(dp_mat_dd, hist_edge_c, 'Normalization', 'pdf');
        dp_hist_id = histcounts(dp_mat_id, hist_edge_c, 'Normalization', 'pdf');
        dp_hist_item_min = 1; % not necessarily 1, but works okay
        dp_hist_scaler_ii = 1;
        dp_hist_scaler_dd = 1;
        dp_hist_scaler_id = 1;
    case 'probability'
        dp_hist_ii = histcounts(dp_mat_ii, hist_edge_c, 'Normalization', 'probability');
        dp_hist_dd = histcounts(dp_mat_dd, hist_edge_c, 'Normalization', 'probability');
        dp_hist_id = histcounts(dp_mat_id, hist_edge_c, 'Normalization', 'probability');
        dp_hist_item_min = 1;
        dp_hist_scaler_ii = 1;
        dp_hist_scaler_dd = 1;
        dp_hist_scaler_id = 1;
    case 'probabilityScaled'
        dp_hist_ii = histcounts(dp_mat_ii, hist_edge_c, 'Normalization', 'probability');
        dp_hist_dd = histcounts(dp_mat_dd, hist_edge_c, 'Normalization', 'probability');
        dp_hist_id = histcounts(dp_mat_id, hist_edge_c, 'Normalization', 'probability');
        dp_hist_item_min = length(dp_center);
        dp_hist_scaler_ii = 1 / dp_hist_item_min;
        dp_hist_scaler_dd = 1 / dp_hist_item_min;
        dp_hist_scaler_id = 1 / dp_hist_item_min;
end

dp_hist_ii = dp_hist_ii ./ dp_hist_scaler_ii;
dp_hist_dd = dp_hist_dd ./ dp_hist_scaler_dd;
dp_hist_id = dp_hist_id ./ dp_hist_scaler_id;

end
