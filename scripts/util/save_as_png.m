function save_as_png(fig_filename)

fig = openfig(fig_filename);
exportgraphics(fig, [fig_filename '.png'], 'ContentType', 'image');
close(fig)

end