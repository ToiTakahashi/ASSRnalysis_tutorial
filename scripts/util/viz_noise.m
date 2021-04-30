function viz_noise(subject_mat)

subject = load(subject_mat);
n_cond = subject.n_cond;

fig = figure();
axs = gobjects(2, 1);

axs(1) = subplot(2,1,1); hold on
for cond = 1:n_cond
    [f, P1] = ret_fft(subject.data_mat{cond}, subject.fs);
    plot(f, P1, '-', 'DisplayName', subject.cond_txt{cond});
end
hold off
legend('NumColumns', 2)
xlabel('[Hz]')
ylabel('[uV]')
title(['Noise: ' subject.subject_ID])

[dur_min, dur_min_idx] = min(subject.dur);
n_sample_min = size(subject.data_mat{dur_min_idx}, 1);
[f, P1] = ret_fft(subject.data_mat{dur_min_idx}, subject.fs);
P1s = zeros(n_cond, length(P1));
for cond = 1:n_cond
    [~, P1s(cond,:)] = ret_fft(subject.data_mat{cond}(1:n_sample_min,:), subject.fs);
end
axs(2) = subplot(2,1,2);
shadedErrorBar(f, P1s, {@mean, @std}, ...
               'lineprops', '-b', 'transparent', true, 'patchSaturation', 0.9)
xlabel('[Hz]')
ylabel('[uV]')
title(['Noise(' num2str(dur_min) 's): ' subject.subject_ID])

linkaxes(axs)
xlim([0, 100])
ylim([0, 5])
tunefig('document', fig)

end