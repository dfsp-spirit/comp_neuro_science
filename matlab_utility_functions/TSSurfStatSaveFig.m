function TSSurfStatSaveFig( filename , view );

% Export figure to image file(s).
%
% Usage: SurfStatSaveFig( clim , 'filename.png');
%
% filenname : string, e.g. 'ct.group.t' or 'ct.group.ct'
% view      : 'o' for overall or 'all' for all individuals
%

if view == 'o'
    fprintf('Saving overall image only.\n');
    export_fig(sprintf('%s', filename), '-transparent', '-r200');
elseif view == 'all'
    fprintf('Saving overall image and all individual views.\n');
    export_fig(sprintf('%s', filename), '-transparent', '-r200');
    h = get(gcf, 'children');

    for i = 1:length(h)
        export_file_name = sprintf('%s.plot%d', filename, i);
        if get(h(i), 'type') == "axes"
            export_fig(h(i), export_file_name, '-transparent', '-r200');
        end
    end
end

return
end
