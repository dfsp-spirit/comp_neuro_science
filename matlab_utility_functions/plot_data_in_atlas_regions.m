function [fh, region_names] = plot_data_in_atlas_regions(data_to_plot, atlas, hemi, subject_id, subjects_dir, visualization_surface, colmap)
% Plots the data values in 'data_to_plot' onto the atlas regions for the given subject.
%
% Parameters:
%
% 'data_to_plot': An array of n numerical values, where n is the number of regions
% defined in the atlas multiplied with the number of hemispheres (see 'hemi' below). This a a matrix with shape (n, 1).
% If the data is for 2 both hemispheres, the data for the left hemi must be
% given first, followed by the data for the right hemi.
%
% 'atlas': string, file name part of the atlas to use. Example: "aparc" will
% load the Desikan labels from the file '<vis_subject_dir>/label/<hemi>.aparc.annot'.
%
% 'hemi': string, must be one of ('lh', 'rh', 'both'). The hemisphere to
% load. Note that if you load both hemispheres, you must give 2n data
% values in 'data_to_plot', where n is the number of atlas regions. The data for
% the left hemisphere must be given first, followed by the data for the
% right hemisphere.
%
% 'subject_id': string, the subject identifier. Example: 'fsaverage' or 'subject1'.
%
% 'subjects_dir': string, path to a directory containing the subject.
% Example: "~/data/mystudy" or "/Applications/freesurfer/subjects".
%
% 'visualization_surface': string, the surface to use for visualization.
% Examples: 'white', 'pial', or 'inflated'. Must exist for subject.
% Deafults to 'white.'
%
% 'colmap': a colormap, e.g., 'jet', 'winter' or whatever. Defaults to
% 'jet'.
%
% Full usage example:
%
% random_data = normrnd(0, 1, [72, 1]);   % Draw 72 values from normal distribution with mean 0 and stddev 1. You may want to plot something that makes more sense. ;)
% [fh, region_names] = plot_data_in_atlas_regions(random_data, "aparc", "both", "bert", "/Applications/freesurfer/subjects", "white")

     if ~exist('visualization_surface', 'var')    
        visualization_surface = 'white';
     end

     if ~exist('colmap', 'var')    
        colmap = jet;
     end

    aparc_file_lh = fullfile(char(subjects_dir), char(subject_id), 'label', char(sprintf("lh.%s.annot", atlas)));
    aparc_file_rh = fullfile(char(subjects_dir), char(subject_id), 'label', char(sprintf("rh.%s.annot", atlas)));


    if exist(aparc_file_lh, 'file') ~= 2
        error("lh atlas file '%s' does not exist. Check the path.\n", aparc_file_lh);
    end
    if exist(aparc_file_rh, 'file') ~= 2
        error("rh atlas file '%s' does not exist. Check the path.\n", aparc_file_rh);
    end

    [~, labels_lh, colortable_lh] = read_annotation(aparc_file_lh);
    [~, labels_rh, ~] = read_annotation(aparc_file_rh);
    region_names = string(colortable_lh.struct_names);
    ctable = colortable_lh.table;

    num_atlas_regions = length(region_names);
    % Check whether data length is suitable
    if strcmp(hemi, "lh") || strcmp(hemi, "rh")
        if length(data_to_plot) ~= num_atlas_regions
            error("Number of data values (%d) must match number of atlas regions (is %d) for hemi setting '%s'.", length(data_to_plot), num_atlas_regions, hemi);
        end
        if strcmp(hemi, "lh")
            for region_idx = 1:num_atlas_regions
                labels_lh(labels_lh == ctable(region_idx, 5)) = data_to_plot(region_idx);
                %labels_rh = zeros(length(labels_rh), 1);
                labels_rh = [];
            end
        end
        if strcmp(hemi, "rh")
            for region_idx = 1:num_atlas_regions
                labels_rh(labels_rh == ctable(region_idx, 5)) = data_to_plot(region_idx);
                %labels_lh = zeros(length(labels_lh), 1);
                labels_lh = [];
            end
        end

    elseif strcmp(hemi, "both")
        if length(data_to_plot) ~= (num_atlas_regions * 2)
            error("Number of data values must be two times the number of atlas regions (%d for atlas %s) for hemi setting '%s': expected %d but found %d values.", num_atlas_regions, atlas, hemi, (num_atlas_regions * 2), length(data_to_plot));
        end

        for region_idx = 1:num_atlas_regions
            labels_lh(labels_lh == ctable(region_idx, 5)) = data_to_plot(region_idx);
            labels_rh(labels_rh == ctable(region_idx, 5)) = data_to_plot(num_atlas_regions + region_idx);
        end
    else
        error("Invalid value for parameter 'hemi'. Must be one of ('lh', 'rh', 'both') but was '%s'.", hemi);
    end

    fh = plot_data_onto_subject(subject_id, subjects_dir, labels_lh, labels_rh, colmap, visualization_surface, '', '');

end
