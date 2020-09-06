function X = haralickDescriptors(img)

%glcms = graycomatrix(img, 'NumLevels', 64, 'offset', [0 1; -1 1; -1 0; -1 -1; 0 2; -2 2; -2 0; -2 -2], 'Symmetric', true);
glcms = graycomatrix(uint8(img), 'NumLevels', 64, 'offset', [0 1; -1 1; -1 0; -1 -1; 0 2; -2 2; -2 0; -2 -2], 'Symmetric', false);

stats = graycoprops(glcms);

%X = [stats.Contrast stats.Correlation stats.Energy stats.Homogeneity];
X = [stats.Contrast stats.Correlation stats.Homogeneity];

%[0 1; -1 1; -1 0; -1 -1; 0 2; -2 2; -2 0; -2 -2]


