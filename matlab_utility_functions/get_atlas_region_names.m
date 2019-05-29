function region_names = get_atlas_region_names(subjects_dir_fsaverage, atlas_file_name)
% Loads the region names from an atlas file. Returns them as a string
% array with shape (n, 1) for n structures in the file.
%
% subjects_dir_fsaverage: string, path to a directory containing the freesurfer 'fsaverage'
% subject.
% atlas_file_name: string, name of the annotation file in the 'label' dir
% of the 'fsaverage' subject. Usually something like 'lh.aparc.annot'. The
% hemi part should not make a difference ('lh' or 'rh' lead to same results).
%

    aparc_file_this_hemi = fullfile(subjects_dir_fsaverage, 'fsaverage', 'label', atlas_file_name);
    [~, ~, colortable] = read_annotation(aparc_file_this_hemi);
    region_names = string(colortable.struct_names);
end