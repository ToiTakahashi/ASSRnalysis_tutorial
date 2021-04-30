clear
addpath('C:\Users\toiap\Documents\workspace\experiments\EEG\ASSR\assr_20200903\EXP\20210413_rion\ASSR_20210413');
%% Specify Params

name = '21TT'; % '17OR';
earinfo = 'L';
m_freq = 40; % 80;
arr_c_freq = [500, 4000, -1];
arr_dbs = {[30, 20, 10, 0, -100], [30, 20, 10, 0], [30, 20, 10, 0]}; % {[30, 20, 10, 0, -100], [30, 20, 10, 0], [30, 20, 10, 10, 0, 0]};
arr_dbnames = {["30", "20", "10", "0", "-100"], ["30", "20", "10", "0"], ["30", "20", "10", "0"]}; % {["30", "20", "10", "0", "-100"], ["30", "20", "10", "0"], ["30", "20", "10_1", "10_2", "0_1", "0_2"]};
subject_filename = ['rion_' name '_' earinfo '_MF' num2str(m_freq) 'Hz.mat'];
%disp(subject_filename)

%% Load Data
cond_id = 1;
arr_fs = [];
t_cond = {};
data_mat = {};
dur = [];
freq_list = [];
loud_list = [];
for c_freq_idx = 1:length(arr_c_freq)
    c_freq = arr_c_freq(c_freq_idx);
    arr_db = arr_dbs{c_freq_idx};
    arr_dbname = arr_dbnames{c_freq_idx};
    for db_idx = 1:length(arr_db)
        db = arr_db(db_idx);
        dbname = arr_dbname(db_idx);
        switch m_freq < 60
            case true, str_m_freq = '40';
            case false, str_m_freq = '80';
        end
        % «only for 09MT2_mf40
%         if db_idx == 5
%             str_m_freq = '80';
%         end
        % ªonly for 09MT2_mf40
        filename = append(name, '_', earinfo, ...
            '_cfreq', num2str(c_freq), '_mfreq', str_m_freq, '_@', dbname);
        %disp(filename)
        load(filename, 'rawdata', 'fs', 'trgdata')

        % ãƒˆãƒªã‚¬ãƒ?ãƒ¼ã‚¿ã‹ã‚‰åˆ?ã‚Šå?ºã—ç¯?å›²ã‚’éŸ³æç¤ºéƒ¨åˆ?ã®ã¿ã‚’å??ã‚Šå?ºã?
        thr_trg = 2;    % threshold of trigger [V]
        arr_idx = find(trgdata > thr_trg);
        rawdata = rawdata(arr_idx(1):arr_idx(end));
        % -> rawdata, fs

        % consistency
        if db == -100 % silence
            db = -1;
        end

        % adjust duration to desired integer value
        dur_tmp = floor(length(rawdata)/fs);
        rawdata = rawdata(1:dur_tmp*fs);

        arr_fs(cond_id) = fs;
        data_mat{cond_id} = rawdata;
        dur(cond_id) = length(rawdata)/fs;
        t_cond{cond_id} = 0:1/fs:(length(rawdata)-1)/fs;
        freq_list(cond_id) = c_freq;
        loud_list(cond_id) = db;
        cond_id = cond_id + 1;
    end
end
n_cond = length(data_mat);
cond_txt = cond_txts(n_cond, freq_list, loud_list); % ('rion', n_cond, freq_list, loud_list);
assert(length(unique(arr_fs))==1, '`fs` inconsistent')

subject_ID = name;
transducer_type = earinfo;
%fs = arr_fs(end);
am_freq = m_freq;

%% Save Data
save(subject_filename, 'subject_ID', 'transducer_type', 'fs', 'am_freq', ...
    'n_cond', 'cond_txt', 'dur', 't_cond', 'data_mat',...
    'freq_list', 'loud_list')
