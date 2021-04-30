function dataCell = load_data(dataDir)
dataMats = dir(dataDir);
dataNum = length(dataMats);
dataCell = {};
idx = 1;
for i = 1:dataNum
    if dataMats(i).isdir
        continue
    else
        filename = dataMats(i).name;
        fileparts = split(filename, '.');
        if strcmp(fileparts{end}, 'mat')
            filepath = [dataDir filesep filename];
            data = load(filepath);
            % data.am_freq
            % data.cond_txt
            % data.data_mat
            % data.dur
            % data.freq_list
            % data.fs
            % data.loud_list
            % data.n_cond
            % data.subject_ID
            % data.t_cond
            % data.transducer_type
            dataCell{idx, 1} = data;
            idx = idx + 1;
        end
    end
end

end
