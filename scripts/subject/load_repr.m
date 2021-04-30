function subjects = load_repr(data_dir, f_repr, l_repr)
dataCell = load_data(data_dir);
n_data = length(dataCell);

subjects = cell(n_data, 1);
for i = 1:n_data
    data = dataCell{i};
    sil_index = find(data.loud_list==-1|data.loud_list==-100, 1); %(data.freq_list==-1&data.loud_list==-1, 1); % first match
    if (l_repr==-1) || (l_repr==-100) %(f_repr==-1) && (l_repr==-1) % silence
        repr_index = find(data.freq_list==f_repr&data.loud_list==l_repr, 2); % second match
        assert(length(repr_index)==2)
        repr_index = repr_index(2);
    else
        repr_index = find(data.freq_list==f_repr&data.loud_list==l_repr, 1); % first match
    end
    subject = struct();
    subject.fs = data.fs;
    subject.am_freq = data.am_freq;
    subject.dur_repr = data.dur(repr_index);
    subject.dur_sil =  data.dur(sil_index);
    subject.data_repr = data.data_mat{repr_index};
    subject.data_sil = data.data_mat{sil_index};
    subjects{i} = subject;
end

end
