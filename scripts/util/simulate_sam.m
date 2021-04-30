function subject = simulate_sam(dur, am_freq, fs, sam_type)
%{
dur = 1;
am_freq = 40;
fs = 500;
sam_type = 'slip'; % 'clean', 'noisy', 'normal', 'uniform', 'slip'
%}

% Parameters
% for 'normal', 'uniform'
clip_len = 25; % 50ms(20*n Hz)

% for 'slip'
slip_per_sec = 10; % refer to data
slip_size = 2*pi/10; % use normal dist?
flip_ratio = 0; % flip direction of slip
rand_ratio = 0; % add noise

% Auxillary Variables
t = (0:1/fs:(dur-1/fs))';
n_sample = numel(t); % fs*dur

t_clip = (0:1/fs:(clip_len-1)/fs)';
n_clip = n_sample/clip_len; % integer

sample_per_slip = fs/slip_per_sec;

% Simulation

switch sam_type
    case 'clean'
        % sam clean
        data_sam = sin(am_freq*2*pi*t);
    case 'noisy'
        % sam noisy
        data_sam = sin(am_freq*2*pi*t)+randn(n_sample,1)/3;
    case 'normal'
        % sam clip normal
        data_phase = randn(n_clip,1) * (pi/2) * (1/4);
        data_sam = zeros(n_sample, 1);
        for j = 1:n_clip
            data_sam(((j-1)*clip_len+1):j*clip_len)...
                = sin(am_freq*2*pi*t_clip+data_phase(j));
        end
    case 'uniform'
        % sam clip uniform
        data_phase = rand(n_clip,1) * (2*pi);
        data_sam = zeros(n_sample, 1);
        for j = 1:n_clip
            data_sam(((j-1)*clip_len+1):j*clip_len)...
                = sin(am_freq*2*pi*t_clip+data_phase(j));
        end
    case 'slip'
        % sam phase slip
        slips = ceil(exprnd(sample_per_slip,[n_sample,1])); % almost no 0. allowing 1.
        slip_ind = cumsum(slips);
        slip_ind = unique(slip_ind); % just making sure
        slip_ind = slip_ind(slip_ind<=n_sample); % (slip_ind<n_sample)?
        n_slip = length(slip_ind);
        slip_dir = ones(n_slip,1);
        n_flip = round(n_slip * flip_ratio);
        flip_ind = randsample(n_slip,n_flip);
        slip_dir(flip_ind) = -1;
        data_sam_base = zeros(n_sample,1);
        cur_phase = 0;
        for ti = 1:n_sample
            slip_ind_t = find(ti==slip_ind);
            if slip_ind_t
                slip = slip_dir(slip_ind_t)*slip_size;
            else
                slip = 0;
            end
            data_sam_base(ti) = sin(cur_phase);
            cur_phase = cur_phase + am_freq*(2*pi*1/fs) + slip;
            if cur_phase >= 2*pi
                cur_phase = cur_phase - 2*pi;
            else
                if cur_phase < 0
                    cur_phase = cur_phase + 2*pi;
                end
            end
        end
        data_rand = randn(n_sample,1);
        data_sam = data_sam_base + rand_ratio * data_rand; % noisy
end

% Visualization

figure;
plot(t, data_sam)

% Create subject

subject = struct();
subject.fs = fs;
subject.am_freq = am_freq;
subject.dur_repr = dur;
subject.data_repr = data_sam;

end
