function r_colormap = get_r_corrplot_colormap_nosteps()
% Generates the colormap used by GNU R for correlation plots using the 'corrplot' R package. The colormap goes from dark blue to light blue to gray, then from light red to dark red.

colormap_256 = [5 48 97
    29 96 164
    60 138 189
    122 182 213
    245 245 245
    231 224 219
    248 197 171
    235 144 114
    206 81 70
    170 20 41
    ];

r_colormap = colormap_256 / 256;

end
