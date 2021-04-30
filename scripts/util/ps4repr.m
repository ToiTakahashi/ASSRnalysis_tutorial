%% Parameters and data loading

data_dir = ['datamats' filesep 'datamat_keio'];
f_repr = 1000;
l_repr = 80;
subjects = load_repr(data_dir, f_repr, l_repr);
n_subject = length(subjects);

preproc_opt = struct();
preproc_opt.mode = 'phase_w_filt';
preproc_opt.order = round(data_fs*1000/1000); % 1000ms
preproc_opt.cutoff = 0.5;

disp(['s-' num2str(n_subject)])

%% Data selection and phase extraction
sub_idx = 1;
%for sub_idx = 1

subject = subjects{sub_idx};
fs = subject.fs;
am_freq = subject.am_freq;
dur_repr = subject.dur_repr;
dur_sil = subject.dur_sil;
data_repr = subject.data_repr;
data_sil = subject.data_sil;

preproc_opt.mf = am_freq;

filt_repr = preproc_dpd_custom_1(data_repr, fs, preproc_opt);
filt_sil = preproc_dpd_custom_1(data_sil, fs, preproc_opt);

%{
figure;ax=gobjects(2);
ax(1)=subplot(2,1,1);
plot(filt_repr, 'DisplayName', 'repr');legend()
title('Phase at MF for repr')
ax(2)=subplot(2,1,2);
plot(filt_sil, 'DisplayName', 'sil');legend()
title('Phase at MF for sil')
linkaxes(ax)
%}

%% Hypothesis 1
% H1: assume normal progress depending on previous sample
normal_progress = am_freq*2*pi/fs;
pd_repr = diff(unwrap(filt_repr)) - normal_progress;
pd_sil = diff(unwrap(filt_sil)) - normal_progress;

%% Hypothesis 2
% H2: assume normal/counter progress depending on SAM
allow_counter = false;
normal_progress = am_freq*2*pi/fs;

n_phase_repr = length(filt_repr);
pd_repr_mean = inf;
%tau_repr = 0; % -pi ~ pi
for tau_repr_c = -pi:pi/128:pi
    normal_repr = tau_repr_c + (-pi:normal_progress:pi)';
    normal_repr(normal_repr>pi) = normal_repr(normal_repr>pi) - 2*pi;
    normal_repr(normal_repr<-pi) = normal_repr(normal_repr<-pi) + 2*pi;
    n_rep = floor(n_phase_repr/length(normal_repr));
    n_left = n_phase_repr - n_rep * length(normal_repr);
    normal_repr = [repmat(normal_repr, n_rep, 1); normal_repr(1:n_left)];
    counter_repr = normal_repr + pi;
    counter_repr(counter_repr>pi) = counter_repr(counter_repr>pi) - 2*pi;
    counter_repr(counter_repr<-pi) = counter_repr(counter_repr<-pi) + 2*pi;

    pd_repr_cn = filt_repr - normal_repr;

    % H2-1. normal only
    pd_repr_c = pd_repr_cn;

    % H2-2. normal OR counter
    if allow_counter
        pd_repr_cc = filt_repr - counter_repr;
        pd_repr_sel_cc = abs(pd_repr_cn) > abs(pd_repr_cc);
        pd_repr_c(pd_repr_sel_cc) = pd_repr_cc(pd_repr_sel_cc);
    end

    % Evaluate offset
    pd_mean_c = mean(abs(pd_repr_c));

    if abs(pd_mean_c) < abs(pd_repr_mean)
        tau_repr = tau_repr_c;
        pd_repr = pd_repr_c;
        if allow_counter
            pd_repr_sel_c = pd_repr_sel_cc;
        end
        pd_repr_mean = pd_mean_c;
    end
end

n_phase_sil = length(filt_sil);
pd_sil_mean = inf;
%tau_sil = 0; % -pi ~ pi
for tau_sil_c = -pi:pi/128:pi
    normal_sil = tau_sil_c + (-pi:normal_progress:pi)';
    normal_sil(normal_sil>pi) = normal_sil(normal_sil>pi) - 2*pi;
    normal_sil(normal_sil<-pi) = normal_sil(normal_sil<-pi) + 2*pi;
    n_rep = floor(n_phase_sil/length(normal_sil));
    n_left = n_phase_sil - n_rep * length(normal_sil);
    normal_sil = [repmat(normal_sil, n_rep, 1); normal_sil(1:n_left)];
    counter_sil = normal_sil + pi;
    counter_sil(counter_sil>pi) = counter_sil(counter_sil>pi) - 2*pi;
    counter_sil(counter_sil<-pi) = counter_sil(counter_sil<-pi) + 2*pi;

    pd_sil_cn = filt_sil - normal_sil;

    % H2-1. normal only
    pd_sil_c = pd_sil_cn;

    % H2-2. normal OR counter
    if allow_counter
        pd_sil_cc = filt_sil - counter_sil;
        pd_sil_sel_cc = abs(pd_sil_cn) > abs(pd_sil_cc);
        pd_sil_c(pd_sil_sel_cc) = pd_sil_cc(pd_sil_sel_cc);
    end

    % Evaluate offset
    pd_mean_c = mean(abs(pd_sil_c));
    if abs(pd_mean_c) < abs(pd_sil_mean)
        tau_sil = tau_sil_c;
        pd_sil = pd_sil_c;
        if allow_counter
            pd_sil_sel_c = pd_sil_sel_cc;
        end
        pd_sil_mean = pd_mean_c;
    end
end

%{
if allow_counter
    figure;ax=gobjects(2);
    subplot(2,5,[1,6])
    histogram(pd_repr_sel_c)
    hold on
    histogram(pd_sil_sel_c)
    hold off
    legend('repr', 'sil')
    title('counter selected')
    ax(1)=subplot(2,5,2:5);
    plot(pd_repr_sel_c, 'k.')
    title('counter selected(repr)')
    ax(2)=subplot(2,5,7:10);
    plot(pd_sil_sel_c, 'k.')
    title('counter selected(sil)')
    linkaxes(ax);
end
%}

%% Vizualize
bin_lim = 2*(2*pi);
bin_num = 100;

bin_edge = (-bin_lim:(bin_lim/bin_num):bin_lim) + (bin_lim/bin_num)/2; bin_edge = bin_edge(1:end-1);

figure;hold on
h1 = histogram(pd_repr, 'FaceColor', 'r', 'BinEdges', bin_edge);
[~,h1_half_idx]=min(abs(cumsum(h1.Values)-length(h1.Data)/2));
h1_half=bin_edge(h1_half_idx)+diff(bin_edge)/2;
h2 = histogram(pd_sil, 'FaceColor', 'b', 'BinEdges', bin_edge);
[~,h2_half_idx]=min(abs(cumsum(h2.Values)-length(h2.Data)/2));
h2_half=bin_edge(h2_half_idx)+diff(bin_edge)/2;
hmax=max([h1.Values h2.Values]);
plot([0;0],[0;hmax],'k--')
plot([h1_half;h1_half],[0;h1.Values(h1_half_idx)],'ro--')
plot([h2_half;h2_half],[0;h2.Values(h2_half_idx)],'bo--')
legend('repr', 'sil');
title('Phase slip with median')

%end % sub_idx
