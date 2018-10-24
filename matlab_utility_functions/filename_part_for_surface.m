function res = filename_part_for_surface(surf)
% Determines the string that represents a surface in FreeSurfer curv output
% files. The white surface is the default and not mentioned at all. For all
% other surfaces, the output files are marked with '.<surface>' in the file name.
    if strcmp(surf, 'white')
        res = '';
    else
        res = sprintf('.%s', surf);
    end
end