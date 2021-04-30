function save_as_pdf(fig_filename)

fig = openfig(fig_filename);
exportgraphics(fig, [fig_filename '.pdf'], 'ContentType', 'vector');
close(fig)

end
