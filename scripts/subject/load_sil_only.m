function subjects = load_sil_only(data_dir, varargin)
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
    data_index = find(data.freq_list==-1&data.loud_list==-1, sel);
    assert(length(data_index)==sel)
    subject = struct();
    subject.fs = data.fs;
    subject.am_freq = data.am_freq;
    subject.dur_sil =  data.dur(data_index(sel));
    subject.data_sil = data.data_mat{data_index(sel)};
    subjects{i} = subject;
end
end
