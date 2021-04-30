function subject = simulate_sil(dur, am_freq, fs)
%{
dur = 1;
am_freq = 40;
fs = 500;
%}

% Auxillary Variables
t = (0:1/fs:(dur-1/fs))';
n_sample = numel(t); % fs*dur

% Simulation
data_sil = randn(n_sample,1)/3;

% Visualization
figure;
plot(t, data_sil)

% Create subject

subject = struct();
subject.fs = fs;
subject.am_freq = am_freq;
subject.dur_repr = dur;
subject.data_repr = data_sil;

end
