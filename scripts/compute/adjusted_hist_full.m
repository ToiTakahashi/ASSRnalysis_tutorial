function [dp_center, dp_hist] = adjusted_hist_full(dp_mat, hist_div, hist_scaler, hist_opt)

hist_elem = hist_scaler / (hist_div - 1);
hist_edge = -(hist_scaler / 2 + hist_elem):hist_elem:(hist_scaler / 2 + hist_elem);
hist_edge_c = hist_edge(1:end - 1) + hist_elem / 2;
dp_center = hist_edge(2:end - 1);

% choose a method of visualization
switch hist_opt
    case 'raw'
        dp_hist = histcounts(dp_mat, hist_edge_c);
    case 'pdf'
        dp_hist = histcounts(dp_mat, hist_edge_c, 'Normalization', 'pdf');
    case 'probability'
        dp_hist = histcounts(dp_mat, hist_edge_c, 'Normalization', 'probability');
    case 'probabilityScaled'
        dp_hist = histcounts(dp_mat, hist_edge_c, 'Normalization', 'probability');
        dp_hist = dp_hist * length(dp_center); % 'raw'?
end

end