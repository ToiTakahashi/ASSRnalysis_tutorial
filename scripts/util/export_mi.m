function seq = export_mi(data_struct)

% obtain max MI sequence
mi = [data_struct.dp_mi{:}]';

[~, mi_max_idx] = max(mi);

seq = data_struct.dp_seq{mi_max_idx};

% start sequence with increasing(1)
seq_len = length(seq);
seq_o = mean(seq(1:2:seq_len));
seq_e = mean(seq(2:2:seq_len));
if seq_o >= seq_e
    assert((seq_o>0)&(seq_e<0)) % req?
    seq = seq(1:(end-1));
else
    assert((seq_o<0)&(seq_e>0)) % req?
    seq = seq(2:end);
end

% return flip indicator
seq_ref = zeros(size(seq));
seq_len = length(seq_ref);
seq_ref(1:2:seq_len) = 1; % inc
seq_ref(2:2:seq_len) = -1; % dec
seq = ((seq .* seq_ref) == -1);

end
