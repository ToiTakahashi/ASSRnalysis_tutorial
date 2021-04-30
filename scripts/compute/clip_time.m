function time_sel = clip_time(n_data, clip_len, clip_j)
% TODO: tuning of idx selection process
time_index_column = (1:n_data)';

j_start = 1 + (clip_j - 1) * clip_len;
if clip_len == round(clip_len)
    % for integer `clip_len`
    j_end = j_start + clip_len - 1;
    time_sel = (time_index_column >= j_start) & (time_index_column <= j_end);
else
    % for float/double `clip_len`
    j_end = j_start + floor(clip_len);
    time_sel = (time_index_column >= j_start) & (time_index_column < j_end);
end

end
