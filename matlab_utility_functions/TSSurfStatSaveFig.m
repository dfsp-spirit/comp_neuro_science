function TSSurfStatSaveFig( filename , view );

% Export figure to image file(s) in PNG format.
%
% Usage: SurfStatSaveFig( clim , 'filename.png');
%
% filenname : string, e.g. 'ct.group.t' or 'ct.group.ct'
% view      : 'o' for overall or 'all' for all individuals
%
%
% Note on the resolution for export_fig, used below: From the README of export_fig:
%   Resolution - by default, export_fig exports bitmaps at screen resolution. However, you may wish to save them at a different resolution. You can do this using either of two options: -m<val>, where is a positive real number, magnifies the figure by the factor for export, e.g. -m2 produces an image double the size (in pixels) of the on screen figure; -r<val>, again where is a positive real number, specifies the output bitmap to have pixels per inch, the dimensions of the figure (in inches) being those of the on screen figure.
if view == 'o'
    fprintf('Saving overall image only.\n');
    export_fig(sprintf('%s', filename), '-transparent', '-r400');
elseif view == 'all'
    fprintf('Saving overall image and all individual views.\n');
    export_fig(sprintf('%s', filename), '-transparent', '-r400');
    h = get(gcf, 'children');

    for i = 1:length(h)
        export_file_name = sprintf('%s.plot%d', filename, i);
        if get(h(i), 'type') == "axes"
            export_fig(h(i), export_file_name, '-transparent', '-r400');
        end
    end
end

return
end
