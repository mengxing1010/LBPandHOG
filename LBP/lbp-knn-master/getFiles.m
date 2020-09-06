function [filenames,classes] = getFiles(image_dir,ext)
%GETFILES Summary of this function goes here
%   Detailed explanation goes here

fnames = dir(fullfile(image_dir, ext));
fnames = fnames(arrayfun(@(x) x.name(1), fnames) ~= '.');
num_files = size(fnames,1);

filenames = cell(num_files,1);
for f = 1:num_files
    filenames{f} = fnames(f).name;
end

classes = cell(num_files,1); %classes das imagens
for i = 1:length(filenames)
    [token, remain] = strtok(filenames{i}, '_');
    classes{i} = token;
end
[x x classes] = unique(classes);

end

