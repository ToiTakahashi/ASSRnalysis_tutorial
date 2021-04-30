function [n_comb, j_seq, k_seq, seq_clip_sep] = comb_index(n_clip)

comb_pattern = 1;
window_width = 1000/50 * 1;

%comb_pattern = 2;
%window_width = 1000/50 * 1; % for comb_pattern = 2
% eg. fs = 500, clip_len = 25 -> 50 msec per clip -> 1000/50 clip per sec * 1 sec [clips per window]

switch comb_pattern
    case 1 % SEQUENTIAL
        n_comb = n_clip * (n_clip - 1) / 2;
        j_seq = zeros(n_comb, 1);
        k_seq = zeros(n_comb, 1);
        seq_clip_sep = zeros(n_clip, 1);
        dp_index = 1;
        for k = 2:n_clip
            for j = 1:(k-1)
                j_seq(dp_index) = j;
                k_seq(dp_index) = k;
                dp_index = dp_index + 1;
            end
            seq_clip_sep(k) = dp_index - 1;
        end
    case 2 % SEQUENTIAL AND LOCAL
        if n_clip <= window_width
            %n_shift = 0;
            n_comb = n_clip * (n_clip - 1) / 2;
            j_seq = zeros(n_comb, 1);
            k_seq = zeros(n_comb, 1);
            seq_clip_sep = zeros(n_clip, 1);
            dp_index = 1;
            for k = 2:n_clip
                for j = 1:(k-1)
                    j_seq(dp_index) = j;
                    k_seq(dp_index) = k;
                    dp_index = dp_index + 1;
                end
                seq_clip_sep(k) = dp_index - 1;
            end
        else
            n_shift = n_clip - window_width;
            n_comb = (window_width*(window_width-1)/2) + n_shift*(window_width-1);
            j_seq = zeros(n_comb, 1);
            k_seq = zeros(n_comb, 1);
            seq_clip_sep = zeros(n_clip, 1);
            dp_index = 1;
            for k = 2:window_width
                for j = 1:(k-1)
                    j_seq(dp_index) = j;
                    k_seq(dp_index) = k;
                    dp_index = dp_index + 1;
                end
                seq_clip_sep(k) = dp_index - 1;
            end
            for i = 1:n_shift
                k = window_width + i;
                for j = (1+i):(k-1)
                    j_seq(dp_index) = j;
                    k_seq(dp_index) = k;
                    dp_index = dp_index + 1;
                end
                seq_clip_sep(k) = dp_index - 1;
            end
        end
end

end
