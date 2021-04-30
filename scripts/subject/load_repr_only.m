function subjects = load_repr_only(data_dir, f_repr, l_repr, varargin)
dataCell = load_data(data_dir);
n_data = length(dataCell);

if isempty(varargin)
    sel = 1;
else
    sel = varargin{1};
end

subjects = cell(n_data, 1);
for i = 1:n_data
    data = dataCell{i};
    data_index = find(data.freq_list==f_repr&data.loud_list==l_repr, sel);
    assert(length(data_index)==sel)
    subject = struct();
    subject.fs = data.fs;
    subject.am_freq = data.am_freq;
    subject.dur_repr = data.dur(data_index(sel));
    subject.data_repr = data.data_mat{data_index(sel)};
    subjects{i} = subject;
end

end
