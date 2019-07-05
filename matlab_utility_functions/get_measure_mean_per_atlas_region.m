function [atlas_regions, mean_per_region] = get_measure_mean_per_atlas_region(subject_id, subjects_dir, measure, surface, hemi, atlas)
% Computes the mean value of some measure (e.g., volume, thickness) for
% each region in an atlas file (e.g., "aparc"). This function uses native
% space data.
%
% Returns an array of region names, and an array of the mean values (both
% in same order).
%
    measure_data = read_subject_data(subject_id, subjects_dir, measure, surface, hemi);
    atlas_file_this_hemi = fullfile(char(subjects_dir), char(subject_id), 'label', char(sprintf("%s.%s.annot", hemi, atlas)));
    [vertices, vertex_labels, colortable] = read_annotation(atlas_file_this_hemi);
    %atlas_regions = string(matlab.lang.makeValidName(colortable.struct_names));
    atlas_regions = string(colortable.struct_names);
    
    
    mean_per_region = zeros(length(atlas_regions), 1);
    
    for region_idx = 1:length(atlas_regions)
        color_code_this_region = colortable.table(region_idx, 5);
        vert_indices = find(vertex_labels(vertex_labels == color_code_this_region));
        mean_lgi_in_region = mean(measure_data(vert_indices));
        mean_per_region(region_idx, 1) = mean_lgi_in_region;
    end
    
end