function auc_val = auc(tprs, fprs)
% ROC: tpr against fpr
% TODO: need better integration method
% cf. trapz, cumtrapz, roc, perfcurve

n_score = length(tprs);
assert(n_score==length(fprs))

if size(tprs, 1) == n_score
    use_col = true;
else
    use_col = false;
end

[fprs_s, tprs_s, ~] = sort_xy(fprs, tprs, use_col);

% support not required with custom sort?
support_threshold = 0.05;
fpr_step = diff(fprs_s);
fpr_leap = find(fpr_step > support_threshold);
if ~isempty(fpr_leap)
    n_leap = length(fpr_leap);
    fpr_supports = [];
    tpr_supports = [];
    for i = 1:n_leap
        leap_idx = fpr_leap(i);
        leap_distance = fprs_s(leap_idx+1) - fprs_s(leap_idx);
        n_support = ceil(leap_distance/support_threshold) - 1;
        xs = linspace(fprs_s(leap_idx), fprs_s(leap_idx+1), 2+n_support);
        ys = linspace(tprs_s(leap_idx), tprs_s(leap_idx+1), 2+n_support);
        fpr_supports = [fpr_supports, xs(2:end-1)];
        tpr_supports = [tpr_supports, ys(2:end-1)];
    end
    if use_col
        fprs_s = [fprs_s; fpr_supports'];
        tprs_s = [tprs_s; tpr_supports'];
    else
        fprs_s = [fprs_s, fpr_supports];
        tprs_s = [tprs_s, tpr_supports];
    end
    [fprs_s, tprs_s, ~] = sort_xy(fprs_s, tprs_s, use_col);
end

auc_val = trapz(fprs_s, tprs_s);

end

function [x_s, y_s, s_idxs] = sort_xy(x, y, use_col)
% Example
%  x = randsample(10, 10, 'true')';
%  y = randsample(10, 10, 'true')';

% sort along x
[x_s, s_idxs1] = sort(x);
y_s = y(s_idxs1);

% sort along y
n_score = length(x_s);
x_inc = diff(x_s);
if use_col
    x_inc_ind = [0; find(x_inc); n_score];
else
    x_inc_ind = [0, find(x_inc), n_score];
end
n_val = length(x_inc_ind)-1;
s_idxs2 = 1:n_score;
for xi = 1:n_val
    val_start = x_inc_ind(xi)+1;
    val_end = x_inc_ind(xi+1);
    y_tmp = y_s(val_start:val_end);
    [~, y_idxs] = sort(y_tmp);
    val_idxs = s_idxs2(val_start:val_end);
    s_idxs2(val_start:val_end) = val_idxs(y_idxs);
end
x_s = x_s(s_idxs2);
y_s = y_s(s_idxs2);
s_idxs = s_idxs1(s_idxs2);

end
