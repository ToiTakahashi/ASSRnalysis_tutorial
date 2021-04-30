function dp_mi = dpm(data_trend)

n_clip = length(data_trend);

% SAM
p_x_i = 0.5;
p_x_d = 0.5;

% EEG
p_y_i = length(find(data_trend == 1)) / n_clip;
p_y_d = length(find(data_trend == -1)) / n_clip;

x_i_index = 1:2:n_clip; % clip_i
x_d_index = 2:2:n_clip; % clip_d

x_i_y_i = length(find(data_trend(x_i_index) == 1)) / n_clip;
x_i_y_d = length(find(data_trend(x_i_index) == -1)) / n_clip;
x_d_y_i = length(find(data_trend(x_d_index) == 1)) / n_clip;
x_d_y_d = length(find(data_trend(x_d_index) == -1)) / n_clip;

dp_mi = x_i_y_i * log2(x_i_y_i / (p_x_i * p_y_i)) ...
    + x_i_y_d * log2(x_i_y_d / (p_x_i * p_y_d)) ...
    + x_d_y_i * log2(x_d_y_i / (p_x_d * p_y_i)) ...
    + x_d_y_d * log2(x_d_y_d / (p_x_d * p_y_d));

end
