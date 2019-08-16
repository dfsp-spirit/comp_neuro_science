function TSSurfStatSaveFig(filename, fileext, view)

% Export figure to image file(s) in PNG format.
%
% Usage: TSSurfStatSaveFig('filename' 'png', 'o');    for overview
%        TSSurfStatSaveFig('filename', 'png', 'all');    for all sub images exported separately
%
% filenname : string, filename without extension
% filext : string, file extension (e.g., 'png')
% view      : 'o' for overall or 'all' for all individual sub images
%
%
% Note on the resolution for export_fig, used below: From the README of export_fig:
%   Resolution - by default, export_fig exports bitmaps at screen resolution. However, you may wish to save them at a different resolution. You can do this using either of two options: -m<val>, where is a positive real number, magnifies the figure by the factor for export, e.g. -m2 produces an image double the size (in pixels) of the on screen figure; -r<val>, again where is a positive real number, specifies the output bitmap to have pixels per inch, the dimensions of the figure (in inches) being those of the on screen figure.

export_overview_filename = sprintf('%s.%s', filename, fileext);
ax = gca;
ax.SortMethod='ChildOrder';

if view == 'o'
    fprintf("Saving overall image only for base file name '%s'.\n", filename);
    export_fig(export_overview_filename, '-r400');
elseif view == 'all'
    fprintf("Saving overall image and all individual views for base file name '%s'.\n", filename);
    export_fig(export_overview_filename, '-r400');

    h = get(gcf, 'children');
    for i = 1:length(h)
        export_subplot_file_name = sprintf('%s_plot%d.%s', filename, i, fileext);
        sub_plot = h(i);
        if get(sub_plot, 'type') == "axes"
            %sub_plot.SortMethod='ChildOrder';
            export_fig(sub_plot, export_subplot_file_name, '-r400');
        end
    end
end

return
end
