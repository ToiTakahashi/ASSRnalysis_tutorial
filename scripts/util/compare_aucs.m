function compare_aucs(durs, dbs, aucs_1, aucs_2, fig_title, fig_dir)

n_row = length(dbs);
assert(n_row==size(aucs_1.aucs, 2))
assert(n_row==size(aucs_2.aucs, 2))

ax = gobjects(n_row, 1);
fig = figure();
for idx = 1:n_row
    ax(idx) = subplot(n_row, 1, idx);
    semilogx(durs, aucs_1.aucs(:, idx), 'ko-'); hold on
    semilogx(durs, aucs_2.aucs(:, idx), 'ro-');
    plot([min(durs); max(durs)], [0.5; 0.5], 'k--'); hold off
    grid on; grid minor;
    xticks(sort(durs))
    xticklabels({})
    ylabel('AUC[-]')
    title([fig_title '-' num2str(dbs(idx)) 'dB' '(K:' aucs_1.type '-R:' aucs_2.type ')'])
end
linkaxes(ax)
if length(durs) > 1
    xlim([min(durs), max(durs)])
end
xticklabels(sort(durs))
ylim([0, 1])
xlabel('measurement[s]')
tunefig('document', fig);

fig_filename = [fig_dir filesep fig_title '.fig'];
savefig(fig_filename)

end
