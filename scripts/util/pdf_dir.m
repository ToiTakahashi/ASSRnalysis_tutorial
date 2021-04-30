function pdf_dir(dirname)

listing = dir(dirname);
n_list = length(listing);
for i = 1:n_list
    if listing(i).isdir
        continue
    else
        filename = [listing(i).folder filesep listing(i).name];
        fileparts = split(filename, '.');
        if strcmp(fileparts{end}, 'fig')
            save_as_pdf(filename)
        end
    end
end

end