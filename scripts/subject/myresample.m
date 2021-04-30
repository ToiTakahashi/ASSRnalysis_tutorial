function data_resampled = myresample(data, fs_pre, fs_post)
% data: n_sample x n_ch
% based on `pop_resample.m` from eeglab
% requires resample() function from Signal Processing Toolbox
% requires firfilt codebase

fc = 0.9; % anti-aliasing filter cutoff (pi rad / sample)
df = 0.2; % anti-aliasing filter transition band width (pi rad / sample)

if length(data) < 2
    data_resampled = data;
    return;
end

% fs_post <- fs_pre*p/q
[p,q] = rat(fs_post/fs_pre, 1e-12);

% Conservative custom anti-aliasing FIR filter
nyq = 1 / max([p q]);
fc = fc * nyq; % Anti-aliasing filter cutoff frequency
df = df * nyq; % Anti-aliasing filter transition band width
m = pop_firwsord('kaiser', 2, df, 0.002); % Anti-aliasing filter kernel
b = firws(m, fc, windows('kaiser', m + 1, 5)); % Anti-aliasing filter kernel
b = p * b; % Normalize filter kernel to inserted zeros

% Padding to avoid artifacts at the beginning and at the end
nPad = ceil((m / 2) / q) * q; % Datapoints to pad, round to integer multiple of q for unpadding
startPad = repmat(data(1, :), [nPad 1]);
endPad = repmat(data(end, :), [nPad 1]);

% Resampling
data_resampled = resample([startPad; data; endPad], p, q, b);

% Remove padding
nPad = nPad * p / q; % # datapoints to unpad
data_resampled = data_resampled(nPad + 1:end - nPad, :); % Remove padded data

end