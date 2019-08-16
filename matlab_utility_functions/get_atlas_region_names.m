function region_names = get_atlas_region_names(subjects_dir, subject, atlas_name)
% Loads the region names from an atlas file. Returns them as a string
% array with shape (n, 1) for n structures in the file.
%
% subjects_dir: string, path to a directory containing the freesurfer
% subject.
% subject: string, subject name.
% atlas_name: string, atlas name. Example: 'aparc' or 'aparc.a2009s'.
%

    aparc_file_this_hemi = fullfile(char(subjects_dir), char(subject), 'label', char(sprintf("lh.%s.annot", atlas_name)));

    if ~ isfile(aparc_file_this_hemi)
     error("get_atlas_region_names: annotation file '%s' cannot be read.", aparc_file_this_hemi)
    end

    %fprintf("Reading file '%s'.\n", aparc_file_this_hemi);
    [~, ~, colortable] = read_annotation(aparc_file_this_hemi);
    region_names = string(matlab.lang.makeValidName(colortable.struct_names));
end
