function compare_aucs_noisy(noise_levels, aucs_1, aucs_2, fig_title, fig_dir)

fig = figure();
hold on;
plot(noise_levels, aucs_1.aucs, 'ko-', 'DisplayName', aucs_1.type)
plot(noise_levels, aucs_2.aucs, 'ro-', 'DisplayName', aucs_2.type)
plot([min(noise_levels); max(noise_levels)], [0.5; 0.5], 'k--', 'DisplayName', '')
hold off
grid on; grid minor;
xticks(sort(noise_levels))
xticklabels(sort(noise_levels))
xlabel('noise std [uV]')
ylabel('AUC[-]')
ylim([0, 1])
legend()
title(fig_title)
tunefig('document', fig)

fig_filename = [fig_dir filesep fig_title '.fig'];
savefig(fig_filename)

end
