function compare_accs(durs, dbs, ms_1, ms_2, fig_title, fig_dir)

n_row = length(dbs);
assert(n_row==size(ms_1.ms, 2))
assert(n_row==size(ms_2.ms, 2))

ax = gobjects(n_row, 1);
fig = figure();
for idx = 1:n_row
    ax(idx) = subplot(n_row, 1, idx); hold on
    semilogx(durs, ms_1.ms(:, idx), 'ko-');
    semilogx(durs, ms_2.ms(:, idx), 'ro-');
    plot([min(durs); max(durs)], [0.5; 0.5], 'k--'); hold off
    grid on; grid minor;
    xticks(sort(durs))
    xticklabels({})
    ylabel('ACC[-]') % using accuracy
    title([fig_title '-' num2str(dbs(idx)) 'dB' '(K:' ms_1.type '-R:' ms_2.type ')'])
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
